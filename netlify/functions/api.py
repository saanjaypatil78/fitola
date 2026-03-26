import sys
from pathlib import Path

from mangum import Mangum

ROOT_DIR = Path(__file__).resolve().parents[2]
BACKEND_DIR = ROOT_DIR / "backend"

if str(BACKEND_DIR) not in sys.path:
    sys.path.append(str(BACKEND_DIR))

from main import app  # noqa: E402

handler = Mangum(app)
