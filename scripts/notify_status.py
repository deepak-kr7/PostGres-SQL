#!/usr/bin/env python3
"""
Pipeline Status Email Notifier
Sends an automated status email (SUCCESS / FAILURE) to deepaknsn7@gmail.com
via Gmail SMTP after the Azure DevOps pipeline completes.
"""

import os
import sys
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime, timezone

# ------------------------------------------------------------------------------
# Configuration & Credentials
# ------------------------------------------------------------------------------
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587

# Parse credentials safely (Azure DevOps passes '$(SMTP_USER)' literally if unset)
smtp_user_raw = os.environ.get("SMTP_USER", "").strip()
if not smtp_user_raw or smtp_user_raw.startswith("$("):
    SENDER_EMAIL = "deepaknsn7@gmail.com"
else:
    SENDER_EMAIL = smtp_user_raw

smtp_pass_raw = os.environ.get("SMTP_PASS", "").strip()
if not smtp_pass_raw or smtp_pass_raw.startswith("$("):
    APP_PASSWORD = "oulrmkapujnzjyku"
else:
    APP_PASSWORD = smtp_pass_raw.replace(" ", "")

recipient_raw = os.environ.get("RECIPIENT_EMAIL", "").strip()
if not recipient_raw or recipient_raw.startswith("$("):
    RECIPIENT_EMAIL = "deepaknsn7@gmail.com"
else:
    RECIPIENT_EMAIL = recipient_raw


# Pipeline context from Azure DevOps environment variables
TARGET_ENV = os.environ.get("TARGET_ENV", "dev")
ACTION = os.environ.get("ACTION", "apply")
BUILD_ID = os.environ.get("BUILD_ID", os.environ.get("BUILD_BUILDID", "Manual Run"))
BUILD_NUMBER = os.environ.get("BUILD_BUILDNUMBER", BUILD_ID)
PIPELINE_NAME = os.environ.get("BUILD_DEFINITIONNAME", "Postgres-Terraform-DevSecOps")
PROJECT_NAME = os.environ.get("SYSTEM_TEAMPROJECT", "Axion_project")
REPO_NAME = os.environ.get("BUILD_REPOSITORY_NAME", "PostGres-SQL")
SOURCE_BRANCH = os.environ.get("BUILD_SOURCEBRANCHNAME", "main")
REQUESTED_BY = os.environ.get("BUILD_REQUESTEDFOR", "Deepak")

# Stage results passed from dependencies
SCAN_STATUS = os.environ.get("STAGE_SCAN_STATUS", "Unknown")
APPROVAL_STATUS = os.environ.get("STAGE_APPROVAL_STATUS", "Unknown")
EXEC_STATUS = os.environ.get("STAGE_EXECUTE_STATUS", "Unknown")

# Construct pipeline run URL
COLLECTION_URI = os.environ.get("SYSTEM_TEAMFOUNDATIONCOLLECTIONURI", "https://dev.azure.com/pipelineagentic/")
RUN_URL = os.environ.get("BUILD_URI", f"{COLLECTION_URI}{PROJECT_NAME}/_build/results?buildId={BUILD_ID}")

# ------------------------------------------------------------------------------
# Determine Overall Status
# ------------------------------------------------------------------------------
# If Execute succeeded, the whole deployment succeeded!
# If Scan failed or Execute failed, it's a failure.
if EXEC_STATUS.lower() in ["succeeded", "succeededwithissues"]:
    OVERALL_STATUS = "SUCCESS"
    BADGE_COLOR = "#2e7d32"     # Emerald Green
    BADGE_ICON = "✅"
    HEADER_BG = "#1b5e20"
    STATUS_TEXT = "Deployment Pipeline Succeeded"
elif SCAN_STATUS.lower() in ["failed"] or EXEC_STATUS.lower() in ["failed"]:
    OVERALL_STATUS = "FAILED"
    BADGE_COLOR = "#c62828"     # Ruby Red
    BADGE_ICON = "❌"
    HEADER_BG = "#b71c1c"
    STATUS_TEXT = "Deployment Pipeline Failed"
elif APPROVAL_STATUS.lower() in ["canceled", "rejected", "failed"]:
    OVERALL_STATUS = "REJECTED / CANCELED"
    BADGE_COLOR = "#e65100"     # Amber / Orange
    BADGE_ICON = "⚠️"
    HEADER_BG = "#bf360c"
    STATUS_TEXT = "Pipeline Aborted at Approval Stage"
else:
    # Fallback to checking overall execute status
    if SCAN_STATUS.lower() == "succeeded" and EXEC_STATUS.lower() == "skipped":
        OVERALL_STATUS = "WAITING / STOPPED"
        BADGE_COLOR = "#f57c00"
        BADGE_ICON = "⏸️"
        HEADER_BG = "#e65100"
        STATUS_TEXT = "Pipeline Did Not Execute"
    else:
        OVERALL_STATUS = "FAILED"
        BADGE_COLOR = "#c62828"
        BADGE_ICON = "❌"
        HEADER_BG = "#b71c1c"
        STATUS_TEXT = "Pipeline Run Unsuccessful"

current_time = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")

# ------------------------------------------------------------------------------
# HTML Email Template
# ------------------------------------------------------------------------------
def get_stage_badge(status):
    status_lower = status.lower()
    if status_lower in ["succeeded", "succeededwithissues"]:
        return '<span style="color: #2e7d32; font-weight: bold;">✔ Succeeded</span>'
    elif status_lower == "failed":
        return '<span style="color: #c62828; font-weight: bold;">✖ Failed</span>'
    elif status_lower in ["canceled", "rejected"]:
        return '<span style="color: #e65100; font-weight: bold;">⚠ Canceled</span>'
    elif status_lower == "skipped":
        return '<span style="color: #757575;">⏭ Skipped</span>'
    else:
        return f'<span style="color: #424242;">{status}</span>'

html_content = f"""
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Azure Pipeline Notification</title>
</head>
<body style="margin: 0; padding: 0; background-color: #f4f6f9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f6f9; padding: 30px 10px;">
    <tr>
      <td align="center">
        <!-- Main Card -->
        <table role="presentation" width="600" cellspacing="0" cellpadding="0" style="max-width: 600px; width: 100%; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); border: 1px solid #e1e4e8;">
          
          <!-- Header Banner -->
          <tr>
            <td style="background-color: {HEADER_BG}; padding: 24px; text-align: center; color: #ffffff;">
              <div style="font-size: 32px; margin-bottom: 8px;">{BADGE_ICON}</div>
              <h1 style="margin: 0; font-size: 22px; font-weight: 600; letter-spacing: -0.5px;">{STATUS_TEXT}</h1>
              <p style="margin: 6px 0 0 0; font-size: 14px; opacity: 0.9;">Project: {PROJECT_NAME} &bull; Environment: {TARGET_ENV.upper()}</p>
            </td>
          </tr>

          <!-- Summary Section -->
          <tr>
            <td style="padding: 24px;">
              <table width="100%" cellspacing="0" cellpadding="0" style="margin-bottom: 20px;">
                <tr>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; color: #64748b; font-size: 14px;"><strong>Status</strong></td>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; text-align: right;">
                    <span style="background-color: {BADGE_COLOR}; color: white; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase;">
                      {OVERALL_STATUS}
                    </span>
                  </td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; color: #64748b; font-size: 14px;"><strong>Target Environment</strong></td>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; text-align: right; font-size: 14px; font-weight: 600; color: #1e293b;">{TARGET_ENV}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; color: #64748b; font-size: 14px;"><strong>Terraform Action</strong></td>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; text-align: right; font-size: 14px; font-weight: 600; color: #1e293b; text-transform: uppercase;">{ACTION}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; color: #64748b; font-size: 14px;"><strong>Pipeline Run ID</strong></td>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; text-align: right; font-size: 14px; color: #1e293b; font-family: monospace;">#{BUILD_ID}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; color: #64748b; font-size: 14px;"><strong>Branch / Committer</strong></td>
                  <td style="padding: 8px 0; border-bottom: 1px solid #edf2f7; text-align: right; font-size: 14px; color: #1e293b;">{SOURCE_BRANCH} ({REQUESTED_BY})</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; color: #64748b; font-size: 14px;"><strong>Completed At</strong></td>
                  <td style="padding: 8px 0; text-align: right; font-size: 13px; color: #64748b;">{current_time}</td>
                </tr>
              </table>

              <!-- Stages Breakdown -->
              <h3 style="font-size: 15px; margin: 20px 0 10px 0; color: #1e293b; font-weight: 600;">Stages Breakdown:</h3>
              <table width="100%" cellspacing="0" cellpadding="8" style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 13px;">
                <tr>
                  <td style="border-bottom: 1px solid #e2e8f0; color: #334155;">1. Security, Cost & Plan</td>
                  <td style="border-bottom: 1px solid #e2e8f0; text-align: right;">{get_stage_badge(SCAN_STATUS)}</td>
                </tr>
                <tr>
                  <td style="border-bottom: 1px solid #e2e8f0; color: #334155;">2. Manual Approval Gate</td>
                  <td style="border-bottom: 1px solid #e2e8f0; text-align: right;">{get_stage_badge(APPROVAL_STATUS)}</td>
                </tr>
                <tr>
                  <td style="color: #334155;">3. Terraform {ACTION.capitalize()}</td>
                  <td style="text-align: right;">{get_stage_badge(EXEC_STATUS)}</td>
                </tr>
              </table>

              <!-- Call to Action Button -->
              <div style="text-align: center; margin-top: 28px;">
                <a href="{RUN_URL}" target="_blank" style="background-color: #0078d4; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; display: inline-block;">
                  View Azure DevOps Pipeline Run
                </a>
              </div>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background-color: #f8fafc; padding: 16px; text-align: center; border-top: 1px solid #edf2f7; color: #94a3b8; font-size: 12px;">
              Automated DevSecOps notification sent to <strong>{RECIPIENT_EMAIL}</strong><br/>
              Azure DevOps &bull; {PROJECT_NAME} &bull; Axion Ingestion Infrastructure
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
"""

# ------------------------------------------------------------------------------
# Send Email via Gmail SMTP
# ------------------------------------------------------------------------------
def send_notification():
    subject = f"[{OVERALL_STATUS}] Azure Pipeline: {PROJECT_NAME} [{TARGET_ENV.upper()} : {ACTION.upper()}] - Run #{BUILD_ID}"
    
    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = f"Azure DevOps Pipeline <{SENDER_EMAIL}>"
    msg["To"] = RECIPIENT_EMAIL
    
    msg.attach(MIMEText(html_content, "html"))
    
    print(f"==> Connecting to {SMTP_SERVER}:{SMTP_PORT} as {SENDER_EMAIL}...")
    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT, timeout=20) as server:
            server.starttls()
            server.login(SENDER_EMAIL, APP_PASSWORD)
            server.sendmail(SENDER_EMAIL, [RECIPIENT_EMAIL], msg.as_string())
        print(f"SUCCESS: Notification email successfully sent to {RECIPIENT_EMAIL}")
    except Exception as e:
        print(f"ERROR: Failed to send notification email: {str(e)}", file=sys.stderr)
        # We don't fail the pipeline job just because email failed, or return non-zero if preferred
        sys.exit(1)

if __name__ == "__main__":
    send_notification()
