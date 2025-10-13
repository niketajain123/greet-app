from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def home():
    fname = None
    sname= " "
    if request.method == "POST":
        fname = request.form.get("fname")
        sname = request.form.get("sname"," ")
    return render_template("index.html", fname=fname, sname=sname)

if __name__ == "__main__":

    app.run(host="0.0.0.0", port=5000)

