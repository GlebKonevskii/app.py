from flask import Flask, request, jsonify, render_template_string

app = Flask(__name__)

html_content = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flask API</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .form-section {
            margin-bottom: 20px;
        }
        .form-section h2 {
            margin-bottom: 10px;
            color: #333;
        }
        input, button {
            padding: 8px;
            margin: 5px 0;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            background-color: #007BFF;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        #response {
            margin-top: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            background-color: #f8f8f8;
            border-radius: 5px;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Flask API Testing</h1>

    <!-- GET Request Form -->
    <div class="form-section">
        <h2>GET Request</h2>
        <form id="getForm">
            <input type="text" id="getParam1" placeholder="param1">
            <input type="text" id="getParam2" placeholder="param2">
            <button type="submit">Send GET Request</button>
        </form>
    </div>

    <!-- POST Request Form -->
    <div class="form-section">
        <h2>POST Request</h2>
        <form id="postForm">
            <input type="text" id="postParam1" placeholder="param1">
            <input type="text" id="postParam2" placeholder="param2">
            <button type="submit">Send POST Request</button>
        </form>
    </div>

    <div id="response"></div>
</div>

<script>
    // Обработчик формы для GET-запроса
    document.getElementById('getForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const param1 = document.getElementById('getParam1').value;
        const param2 = document.getElementById('getParam2').value;

        fetch(`/get_route?param1=${param1}&param2=${param2}`, { method: 'GET' })
            .then(response => response.json())
            .then(data => {
                document.getElementById('response').innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
            })
            .catch(error => {
                document.getElementById('response').innerHTML = 'Ошибка: ' + error.message;
            });
    });

    // Обработчик формы для POST-запроса
    document.getElementById('postForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const param1 = document.getElementById('postParam1').value;
        const param2 = document.getElementById('postParam2').value;

        const formData = new FormData();
        formData.append('param1', param1);
        formData.append('param2', param2);

        fetch('/post_route', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            document.getElementById('response').innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
        })
        .catch(error => {
            document.getElementById('response').innerHTML = 'Ошибка: ' + error.message;
        });
    });
</script>

</body>
</html>
"""

@app.route('/get_route', methods=['GET'])
def get_route():
    if request.method == 'GET':
        params = request.args.to_dict()  
        return jsonify(params)
    else:
        return "Метод не поддерживается", 405

@app.route('/post_route', methods=['POST'])
def post_route():
    if request.method == 'POST':
        params = request.form.to_dict()  
        return jsonify(params)
    else:
        return "Метод не поддерживается", 405

@app.route('/head_route', methods=['HEAD'])
def head_route():
    if request.method == 'HEAD':
        return '', 200  
    else:
        return "Метод не поддерживается", 405

@app.route('/options_route', methods=['OPTIONS'])
def options_route():
    if request.method == 'OPTIONS':
        return "Методы, поддерживаемые этим роутом: OPTIONS", 200
    else:
        return "Метод не поддерживается", 405

@app.route('/')
def index():
    return render_template_string(html_content)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
