from setuptools import setup, find_packages

setup(
    name="vault-backend",
    version="1.0.0",
    description="Vault Personal Manager Backend API",
    packages=find_packages(),
    install_requires=[
        "fastapi>=0.104.1",
        "uvicorn[standard]>=0.24.0",
        "sqlalchemy>=2.0.23",
        "pydantic>=2.5.0",
        "python-multipart>=0.0.6",
        "python-dateutil>=2.8.2",
    ],
    python_requires=">=3.8",
)
