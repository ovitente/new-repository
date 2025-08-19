"""
Example Python module demonstrating best practices and security measures.
This file serves as a template for new Python projects.
"""

import os
import logging
from typing import Optional, Dict, Any
from dataclasses import dataclass
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Constants
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30
API_BASE_URL = os.getenv("API_BASE_URL", "https://api.example.com")


@dataclass
class Config:
    """Configuration class for application settings."""
    
    api_key: str
    timeout: int = DEFAULT_TIMEOUT
    max_retries: int = MAX_RETRIES
    
    def __post_init__(self) -> None:
        """Validate configuration after initialization."""
        if not self.api_key:
            raise ValueError("API key is required")
        if self.timeout <= 0:
            raise ValueError("Timeout must be positive")
        if self.max_retries < 0:
            raise ValueError("Max retries cannot be negative")


class SecureAPI:
    """Secure API client with proper error handling and logging."""
    
    def __init__(self, config: Config) -> None:
        """Initialize the API client with configuration."""
        self.config = config
        self.session = self._create_session()
    
    def _create_session(self) -> Any:
        """Create a secure HTTP session."""
        try:
            import requests
            session = requests.Session()
            session.headers.update({
                "Authorization": f"Bearer {self.config.api_key}",
                "Content-Type": "application/json",
                "User-Agent": "SecureAPI/1.0"
            })
            return session
        except ImportError:
            logger.error("requests library not available")
            raise
    
    def make_request(self, endpoint: str, method: str = "GET", data: Optional[Dict] = None) -> Dict[str, Any]:
        """Make a secure API request with proper error handling."""
        url = f"{API_BASE_URL}/{endpoint.lstrip('/')}"
        
        try:
            response = self.session.request(
                method=method,
                url=url,
                json=data,
                timeout=self.config.timeout
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"API request failed: {e}")
            raise
    
    def get_user_info(self, user_id: str) -> Dict[str, Any]:
        """Get user information securely."""
        if not user_id or not user_id.strip():
            raise ValueError("User ID is required")
        
        return self.make_request(f"users/{user_id}")


def validate_input(data: str) -> bool:
    """Validate user input to prevent injection attacks."""
    if not data or not isinstance(data, str):
        return False
    
    # Check for potentially dangerous patterns
    dangerous_patterns = [
        "<script>",
        "javascript:",
        "data:text/html",
        "vbscript:",
        "onload=",
        "onerror="
    ]
    
    data_lower = data.lower()
    for pattern in dangerous_patterns:
        if pattern in data_lower:
            logger.warning(f"Potentially dangerous input detected: {pattern}")
            return False
    
    return True


def safe_file_operation(file_path: str, operation: str = "read") -> Optional[str]:
    """Perform safe file operations with proper path validation."""
    try:
        path = Path(file_path).resolve()
        
        # Prevent directory traversal attacks
        if ".." in str(path):
            logger.error("Directory traversal attempt detected")
            return None
        
        # Ensure file is within allowed directory
        allowed_dir = Path("/allowed/directory").resolve()
        if not str(path).startswith(str(allowed_dir)):
            logger.error("File access outside allowed directory")
            return None
        
        if operation == "read":
            return path.read_text(encoding="utf-8")
        elif operation == "write":
            # Implement write operation here
            pass
        
    except Exception as e:
        logger.error(f"File operation failed: {e}")
        return None
    
    return None


def main() -> None:
    """Main function demonstrating secure practices."""
    try:
        # Get API key from environment (secure way)
        api_key = os.getenv("API_KEY")
        if not api_key:
            logger.error("API_KEY environment variable not set")
            return
        
        # Create configuration
        config = Config(api_key=api_key)
        
        # Create API client
        api_client = SecureAPI(config)
        
        # Example usage
        user_info = api_client.get_user_info("12345")
        logger.info(f"Retrieved user info: {user_info}")
        
    except Exception as e:
        logger.error(f"Application error: {e}")


if __name__ == "__main__":
    main() 