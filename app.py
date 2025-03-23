from flask import Flask
import time

app = Flask(__name__)

@app.route('/')
def index():
    return "Hello, world! The app is running smoothly."

@app.route('/simulate_load')
def simulate_load():
    # Simulate a CPU-intensive task
    total = 0
    for i in range(1, 100000000):
        total += i
    return f"Simulated load complete. Total = {total}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
