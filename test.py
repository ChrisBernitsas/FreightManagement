import requests
import json

# Your data
data = [
    {'truck_id': 1, 'start_location': {'x': 100, 'y': -83.4446278}, 'end_location': {'x': 45.4316941, 'y': -81.4446278}, 'current_point': {'x': 43.4316941, 'y': -82.4446278},},
    # Add the rest of your data here...
]

# The URL to your Firebase Hosting emulator endpoint
url = "https://bananapeel-891ee.web.app/"  # Adjust the port if needed

# Send a POST request
response = requests.post(url, json=data)

# Print the response
print(response.status_code)
print(response.json())