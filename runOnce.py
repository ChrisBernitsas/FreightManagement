import googlemaps
from pprint import pprint
import requests
import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime


cred = credentials.Certificate("/Users/chrisbernitsas/Desktop/bananapeel-891ee-firebase-adminsdk-og3j3-4b29c6267c.json")
# firebase_admin.initialize_app(cred, {
#     'databaseURL': 'https://bananapeel-44e4c-default-rtdb.firebaseio.com/'
# })

firebase_admin.initialize_app(cred)

db = firestore.client()

global points_ref

# Pushing data
def push_data(points, ETA, latStart, longStart, ogLat, ogLong, oeta, endLat, endLong, truckN):
    driver_data = {
        "email": f"driver{truckN}@example.com",
        "name": f"driver{truckN}"
    }

    currentPoint = {
        "ccoor" : [latStart, longStart],
        "ceta" : ETA,
        "points" : points,
        "ocoor" : [ogLat, ogLong],
        "ecoor" : [endLat, endLong],
        "oeta" : oeta
    }
    
    doc_ref = db.collection("companies").document("company1")

    # Set data for driver in the "drivers" subcollection
    driver_ref = doc_ref.collection("drivers").document(f"driver{truckN}")
    driver_ref.set(driver_data)

    # Set data for trips in the "trips" subcollection
    trip_ref = driver_ref.collection("trips").document("trip1")

    # Set data for points in the "points" subcollection
    points_ref = trip_ref.collection("points").document("currentPoint")
    points_ref.set(currentPoint)

def computeGoogleGraphs(start_point, end_point):
    api_key = "AIzaSyBe-bPIDxxP2OxqSqr-o_-Jj6Lqt6JQjKs"
    map_client = googlemaps.Client(api_key)
    response = map_client.directions(start_point, end_point, mode = "driving", alternatives = True)

    allVertices = []
    allEdges = []
    allVerticesForOutput = []
    for i, res in enumerate(response):
        # pprint(res)
        curGraph = getGraph(res, start_point)
        vertices, edges, verticesForOutput = curGraph
        allVertices.append(vertices)
        allEdges.append(edges)
        allVerticesForOutput.append(verticesForOutput)

    #pad so length is always 3, so reciever is okay and doesn't die
    while (len(res) < 3):
        res.append([None])

    graphs = {'vertices' : allVertices,
              'edges' : allEdges}

    return graphs, allVerticesForOutput

def getGraph(path, startPosition):
    startEnd = path['bounds']
    # start = startEnd['']
    allLegs = path['legs'] #[{}, {}, {}]
    allLegs = allLegs[0]
    steps = allLegs['steps']
    vertices = [] # {}
    edges = [] # {}
    verticesForOuput = []
    startX, startY = startPosition
    startVertexForOuput = { 'lat' : startX,
                            'lng' : startY}
    startVertex = { 'x' : startX,
                    'y' : startY,
                    'num' : 0}
    verticesForOuput.append(startVertexForOuput)
    vertices.append(startVertex)
    num = 0
    for step in steps:
        num += 1
        edgeCostTemp = step['duration']
        edgeCost = edgeCostTemp['value'] # value of the TIME/DURATION

        endPos = step['end_location']
        endX, endY = endPos['lat'], endPos['lng']
        # edgeCost = step['distance']
        vertex = { 'x' : endX,
                   'y' : endY,
                   'num' : num }
        edge = { 'cost' : edgeCost,
                 'num' : num - 1}
        vertexForOuput = { 'lat' : endX,
                            'lng' : endY}
        verticesForOuput.append(vertexForOuput)
        vertices.append(vertex)
        edges.append(edge)
    return vertices, edges, verticesForOuput

def modifyWithConstruction(vertices, edges):
    keyThing = "t1eLKWflObPdgVHayVMT1NIUjgKJLsr9"
    url = "https://www.mapquestapi.com/traffic/v2/incidents?key=t1eLKWflObPdgVHayVMT1NIUjgKJLsr9&boundingBox=42.63,-83.13,42.43,-83.44&filters=construction"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
    else:
        print(f"Error: {response.status_code}, {response.text}")
    
    incidents = data['incidents']
    for incident in incidents:
        lat, lng = incident['lat'], incident['lng']
        if 'shoulder' in incident['fullDesc']:
            continue
        if (('Ramp' not in incident['fullDesc']) and ('On-ramp' not in incident['fullDesc'])):
            continue
        else:
            vertices, edges = findWithinNodes(vertices, edges, lat, lng)
    return (vertices, edges)

def findWithinNodes(vertices, edges, lat, lng):
    for i in range(len(vertices)):
        vertex = vertices[i]
        curEdge = edges[i]
        for j in range(1, len(vertex)):
            vertex1, vertex2 = vertex[j - 1], vertex[j]
            x1, y1, = vertex1['x'], vertex1['y']
            x2, y2, = vertex2['x'], vertex2['y']
            if withinBounds(x1, y1, x2, y2, lat, lng):
                for edge in curEdge:
                    if edge['num'] == j:
                        edge['cost'] *= 1.03
    return (vertices, edges)

def withinBounds(x1, y1, x2, y2, xTarget, yTarget):
    if y1 > y2:
        y1, y2 = y2, y1
    if x1 > x2:
        x1, x2 = x2, x1
    return (x1 <= xTarget and xTarget <= x2 and y1 <= yTarget and yTarget <= y2)

def modifyWithWeather(vertices, edges):
    client_id = "cRTYTMKRp9shNf4bVrjdr"
    #action = ":id"
    client_secret = "ev9BUsYzISTpHtexcRc2TCSoOn0MALCnvx5q87bI"
    for i in range(len(vertices)):
        pathVertices = vertices[i]
        allEdges = edges[i]
        for vertex in pathVertices:
            lat, lng = vertex['x'], vertex['y']
            for edge in allEdges:
                if (edge['num'] == (vertex['num'] - 1)):
                    time = edge['num']
                    break
            # url = f"https://api.aerisapi.com/roadweather/{lat},{lng}?client_id={client_id}&client_secret={client_secret}"
            url = f"https://api.aerisapi.com/roadweather/{lat},{lng}?client_id={client_id}&client_secret={client_secret}"
            response = requests.get(url)
            if response.status_code == 200:
                data = response.json()
            else:
                print(f"Error: {response.status_code}, {response.text}")
                continue
            if data.get('error', None) != None:
                if data['error']['description'] == "No nearby supported roads found": continue
                if data['error']['description'] == "Maximum number of daily accesses reached.": break
            periods = data['response'][0]['periods']
            listConditions = [] # (time, color)
            for period in periods:
                timeStamp = period['dateTimeISO']
                timeStamp = timeStamp.split(":")
                timeStomped = timeStamp[0][-2:] + timeStamp[1][-2:]
                timeStomped = int(timeStomped)
                listConditions.append((timeStomped, period['summary']))

            now = datetime.now()
            current_time = now.strftime("%H:%M:%S")
            curTime = current_time.split(":")
            curTime = curTime[0] + curTime[1]
            curTime = int(curTime)
            indexClosest = 0
            timeDiffLowest = 2309223
            for i, period in enumerate(listConditions):
                time, color = period
                timeDiff = abs(curTime - time)
                if timeDiff < timeDiffLowest:
                    timeDiffLowest = timeDiff
                    indexClosest = i
            time, color = listConditions[i]
            colorMatch = { "GREEN" : 1,
                           "YELLOW" : 1.05,
                           "RED" : 1.1}
            edge['cost'] *= colorMatch[color]
    return vertices, edges

def getBestPath (vertices, edges):
    totalTimes = []
    bestPath = [-1, 238942142]
    for i in range(len(edges)):
        allEdges = edges[i]
        pathTime = 0
        for edge in allEdges:
            pathTime += edge['cost']
        totalTimes.append(pathTime)
        if pathTime < bestPath[1]:
            bestPath = [i, pathTime]
    return bestPath
def main():
    #take in data
    startPoint = 42.6340862, -83.1387602
    endPoint = 42.4316941,-83.4446278

    ogPoint = 742.6340862, 983.1387602
    truckN = 7

    latStart, longStart = startPoint
    ogLat, ogLong = ogPoint
    endLat, endLong = endPoint
    
    result = computeGoogleGraphs(startPoint, endPoint)
    graphs, verticesForOutput = result
    vertices, edges = graphs['vertices'], graphs['edges']
    vertices, edges = modifyWithConstruction(vertices, edges)
    vertices, edges = modifyWithWeather(vertices, edges)
    bestI, bestPathTime = getBestPath(vertices, edges)
    points = verticesForOutput[bestI]
    # pprint(verticesForOutput)
    # verticesForOutputV2 =[]
    # pprint(verticesForOutput)
    # for v in verticesForOutput:
    #     for z in v:
    #         z['distance'] = {'x': endLat, "y":endLong}
    #         # z['ID'] = truckN
    #     verticesForOutputV2.append(v)
    # pprint(verticesForOutputV2)
    ogResult = computeGoogleGraphs(ogLat, ogLong)
    ogGraphs, ogVerticesForOutput = ogResult
    ogVertices, ogEdges = ogGraphs['vertices'], ogGraphs['edges']
    ogVertices, ogEdges = modifyWithConstruction(ogVertices, ogEdges)
    ogVertices, ogEdges = modifyWithWeather(ogVertices, ogEdges)
    ogBestI, ogBestPathTime = getBestPath(ogVertices, ogEdges)
    oeta = ogBestPathTime

    push_data(points, bestPathTime, latStart, longStart, ogLat, ogLong, oeta, endLat, endLong, truckN)
    return 1
main()