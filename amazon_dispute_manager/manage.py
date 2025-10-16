#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'amazon_dispute_manager.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        # Provide a clearer, actionable message for developers who haven't
        # installed dependencies or activated a virtual environment yet.
        msg = (
            "Couldn't import Django. Make sure you have installed project "
            "dependencies and activated your virtual environment.\n"
            "Run (Windows PowerShell): \n"
            "  python -m venv .venv; .\\.venv\\Scripts\\Activate.ps1; "
            "python -m pip install -r requirements.txt\n"
        )
        print(msg)
        raise ImportError(msg) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
