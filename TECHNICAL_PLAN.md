# Allston-Brighton Transportation Advocacy Site Plan

## 1. Site Structure & Features

### Core Pages
* **Home Page:**
  * Mission statement (brief, impactful).
  * The most urgent/current "Call to Action".
  * Upcoming events.
* **Take Action (Campaigns):**
  * A list of current initiatives with templates to email stakeholders via `mailto:` links.
* **Interactive Sentiment Map (NEW):**
  * A map of the Allston-Brighton neighborhood where users can draw lines or place points.
  * Users attach an emoji sentiment (😊, 😢, 😠, 😕) to their drawing to indicate what's working and what isn't.
  * The map defaults to a **heatmap view** to easily spot clusters of positive and negative sentiment.
* **Events Calendar:**
  * A chronological list of upcoming meetings, rides, and neighborhood events.

## 2. Proposed Technology Stack

We will maintain the static site foundation for speed and ease of hosting, but introduce a lightweight backend for the map data.

* **Framework:** [Astro](https://astro.build/) with Tailwind CSS.
* **Map Engine:** [Mapbox GL JS](https://www.mapbox.com/) or [MapLibre GL JS](https://maplibre.org/) (an open-source Mapbox alternative). Both have excellent built-in support for heatmaps and drawing tools.
* **Backend Database:** [Supabase](https://supabase.com/). Excellent for storing geographic data (PostGIS) and provides an easy-to-use API for our Astro frontend.
* **Content Management:** Markdown (`.md` or `.mdx`) files for Campaigns and Events.
* **Hosting:** [Render](https://render.com/) (Static Site tier).

## 3. Map Feature Implementation Details

### Data Storage (Supabase)
We will create a table named `map_submissions` with the following columns:
* `id`: UUID (Primary Key)
* `geo_data`: JSONB (Stores the GeoJSON of the point or line drawn)
* `sentiment`: String (The emoji chosen)
* `user_identifier`: String (A unique ID generated and stored in the user's browser `localStorage` or a hashed IP for basic tracking).
* `created_at`: Timestamp

### Spam Prevention
* We will use a unique `user_identifier` stored in `localStorage`. If a user gets overly enthusiastic with spam, you can easily run a query in Supabase to delete all submissions matching that identifier.
* We can implement basic client-side rate limiting (e.g., max 5 submissions per day per device) and potentially a Supabase Edge Function to enforce server-side rate limits based on the IP address.

### The User Experience
1. User lands on the map page. The map displays a heatmap layer powered by existing data in Supabase.
2. User clicks a "Share Your Experience" button.
3. They select either a "Draw Route" (line) or "Mark Spot" (point) tool.
4. They draw on the map.
5. A popup prompts them to select an emoji (😊, 😢, 😠, 😕).
6. Upon selection, the data is sent to Supabase and immediately rendered on their map.

## 4. Implementation Steps

1. **Project Setup:** Initialize the Astro + Tailwind project.
2. **Database Setup:** Create the Supabase project and the `map_submissions` table.
3. **Map Integration:** Build the interactive map component using MapLibre/Mapbox, integrating the drawing tools.
4. **Content & Layout:** Build the markdown-driven Campaigns and Events pages.
5. **Deployment:** Connect the repository to Render for automatic deployments.
