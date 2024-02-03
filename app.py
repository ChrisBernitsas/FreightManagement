from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit
import googlemaps  # Assuming the Google Maps API client is needed
import os
from runOnce import computeGoogleGraphs, push_data, modifyWithConstruction, modifyWithWeather, getBestPath  # Import your existing functions here

app = Flask(__name__)
socketio = SocketIO(app)

# Initialize your Google Maps client here
gmaps = googlemaps.Client(key="AIzaSyBe-bPIDxxP2OxqSqr-o_-Jj6Lqt6JQjKs")

# @app.route('/route', methods=['GET'])
# def find_data(){

# }

@app.route('/route', methods=['POST'])
def calculate_route():
    data = request.json
    start_point = data['start_location']
    end_point = data['end_location']
    current_point = data['current_point']
    truck_id = data['truck_id']  # Example of how you might receive data
    # Here, integrate your logic to compute the route, modify it, and choose the best path
    result = computeGoogleGraphs(start_point, end_point)
    # Perform any additional logic here
    latStart, longStart = current_point
    ogLat, ogLong = start_point
    endLat, endLong = end_point
    
    result = computeGoogleGraphs(start_point, end_point)
    graphs, verticesForOutput = result
    vertices, edges = graphs['vertices'], graphs['edges']
    vertices, edges = modifyWithConstruction(vertices, edges)
    vertices, edges = modifyWithWeather(vertices, edges)
    bestI, bestPathTime = getBestPath(vertices, edges)
    points = verticesForOutput[bestI]

    ogResult = computeGoogleGraphs(start_point, end_point)
    graphs, verticesForOutput = result
    vertices, edges = graphs['vertices'], graphs['edges']
    bestI, bestPathTime = getBestPath(vertices, edges)
    oeta = bestPathTime
    push_data(points, bestPathTime, latStart, longStart, ogLat, ogLong, oeta, endLat, endLong, truck_id)
    return jsonify(result)

@socketio.on('connect')
def handle_connect():
    print('Client connected')

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

@socketio.on('calculate_route')
def handle_calculate_route(data):
    start_point = data['start_location']
    end_point = data['end_location']
    truck_id = data['truck_id']
    
    # Integrate your logic here, similar to the route handler
    result = computeGoogleGraphs(start_point, end_point)
    # Push data to Firestore or perform other actions
    emit('route_response', result)  # Send the result back to the client

if __name__ == '__main__':
    socketio.run(app, debug=True, host='https://bananapeel-891ee.web.app/')