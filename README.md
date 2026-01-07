# Food Rescue Hub Demo

A Drupal 11 proof-of-concept demonstrating CMS site-building, theming, and deployment for a nonprofit-style food rescue platform.

This project was built as a time-boxed demo to showcase Drupal fundamentals, content modeling, theming, and real-world deployment workflows.

---

## Purpose

This demo was created to demonstrate:
- Rapid onboarding to Drupal
- Content modeling and Views configuration
- Custom theming with Twig + CSS
- Local development using Docker
- Deployment to AWS EC2

The concept models a simple food rescue workflow where organizations post available food and volunteers can sign up to help with delivery.

---

## Features

- Drupal 11
- Custom content types (Food Listings, Delivery Signups)
- Views-based listings
- Custom Drupal theme (`food_rescue`)
- Navigation and layout customization
- Sample content included

---

## Custom Theme

- Built from scratch
- Custom CSS for layout and navigation
- Twig templates where appropriate
- Structured for extensibility and accessibility

Theme location:
```
web/themes/custom/food_rescue/
```

---

## Local Development (Docker)

### Requirements
- Docker
- Docker Compose

### Start the site
```bash
docker compose up -d --build
```

Access the site at:
```
http://localhost:8080
```

### Clear cache
```bash
docker compose exec web drush cr
```

---

## Deployment

- Deployed on AWS EC2
- Apache + PHP 8.3
- MariaDB 10.6
- Docker used for local + production parity
- SSH-based GitHub authentication

---

## Design & Technical Tradeoffs

- Time-boxed scope: focused on core Drupal concepts
- Simplicity over abstraction for clarity
- Generated runtime files excluded from version control
- Production-like Docker + EC2 setup to mirror nonprofit environments

---

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── composer.json
├── drupal.sql
├── web/
│   ├── core/
│   ├── modules/
│   ├── themes/
│   │   └── custom/food_rescue/
│   └── sites/
└── vendor/
```

---

## Author

Adrian Vera

Built as a focused demonstration of Drupal front-end development, CMS architecture, and deployment skills for mission-driven organizations.

---

Note:  
This project is a proof-of-concept and not intended for production use without additional security and operational hardening.

