#!/bin/bash

# Function to check the status of the last command and exit if it failed
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed to start."
        exit 1
    fi
}

# Run ChromaDB
echo "Starting ChromaDB..."
chroma run --path /SDA/stage4/ChromaDB &
check_status "ChromaDB"

# Run Backend API
echo "Starting Backend API..."
uvicorn backend:app --reload --port 5000 &
check_status "Backend API"

# Run Streamlit
echo "Starting Streamlit..."
cd /SDA/stage4 || exit
streamlit run chatbot.py &
check_status "Streamlit"

# Wait for all background processes to finish
wait
echo "All services started."
