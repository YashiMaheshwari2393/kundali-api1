# 🪐 Kundali API — Crow + C++ on Render

A lightweight birth-chart (Kundali) REST API built with **C++ + Crow**, containerised with **Docker**, and ready to deploy on **Render**.

---

## 📁 Project Structure

```
.
├── kundali.cpp      # Crow web server + Kundali logic
├── Dockerfile       # Multi-stage Docker build
└── README.md
```

---

## 🚀 Deploy to Render (step-by-step)

### 1. Push to GitHub
```bash
git init
git add kundali.cpp Dockerfile README.md
git commit -m "Initial commit – Kundali Crow API"
git remote add origin https://github.com/YOUR_USERNAME/kundali-api.git
git push -u origin main
```

### 2. Create a Web Service on Render
1. Go to [render.com](https://render.com) → **New → Web Service**
2. Connect your GitHub repo
3. Set the following:

| Setting | Value |
|---|---|
| **Environment** | Docker |
| **Dockerfile Path** | `./Dockerfile` |
| **Port** | `8080` |

4. Click **Deploy** — Render will build and launch your container automatically.

---

## 📡 API Reference

### `GET /`
Health check.
```
200 OK  →  "Kundali API is running! POST to /kundali"
```

### `GET /kundali`
Usage hint with example payload.

### `POST /kundali`
Generate a Kundali.

**Request body (JSON):**
```json
{
  "name":  "Arjun",
  "day":   15,
  "month": 8,
  "year":  2000,
  "place": "Delhi"
}
```

**Response (JSON):**
```json
{
  "name":           "Arjun",
  "place_of_birth": "Delhi",
  "date_of_birth":  "15-8-2000",
  "zodiac_sign":    "Leo (Singh)",
  "lucky_quotes":   ["...", "...", "..."],
  "special_message":"The universe has great plans for you, Arjun!"
}
```

---

## 🧪 Test Locally (with Docker)

```bash
docker build -t kundali-api .
docker run -p 8080:8080 kundali-api

# In another terminal:
curl -X POST http://localhost:8080/kundali \
  -H "Content-Type: application/json" \
  -d '{"name":"Arjun","day":15,"month":8,"year":2000,"place":"Delhi"}'
```

---

## ⚙️ Environment Variables

| Variable | Description | Default |
|---|---|---|
| `PORT` | Port the server listens on (auto-set by Render) | `8080` |
