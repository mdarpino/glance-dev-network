API_URL = "https://fantrax-hockey-api-test.replit.app/api/fantrax/matchups"


# ------------------------------------------------------------
# DATA
# ------------------------------------------------------------

def fetch_data(ctx):
    apikey = ctx.inputs.get("apikey", "")

    if not apikey:
        return None

    resp = http.get(
        API_URL,
        headers = {
            "Authorization": "Bearer " + apikey,
            "Accept": "application/json",
        },
        ttl_seconds = 300,
    )

    if resp["status_code"] != 200:
        return None

    if resp["json"] == None:
        return None

    return resp["json"]


def get_matchups(data):
    if data == None:
        return []

    matchups = data.get("matchups", [])

    if not matchups:
        matchups = data.get("ticker_sample", [])

    return matchups or []


# ------------------------------------------------------------
# TEAM HELPERS
# ------------------------------------------------------------

def safe_str(value):
    if value == None:
        return ""

    return str(value)


def team_name(team):
    if team == None:
        return "TEAM"

    name = team.get("name", "")

    if not name:
        name = team.get("short_name", "")

    if not name:
        name = "TEAM"

    return safe_str(name).upper()


def team_score(team):
    if team == None:
        return ""

    score = team.get("score")

    if score == None:
        return "0"

    return safe_str(score)


def team_logo_asset(team):
    name = team_name(team)

    if name == "CROSSFIT PREEMS":
        return "crossfit-preems.png"

    if name == "DARPS":
        return "darps.png"

    if name == "EV":
        return "ev.png"

    if name == "FASH":
        return "fash.png"

    if name.startswith("GODSPLAN"):
        return "godsplan.png"

    if name == "GREEK":
        return "greek.png"

    if name == "HEBREW SCHOOL OF ECONOMICS":
        return "hebrew-school-of-economics.png"

    if name == "MIKEVERRELLI11":
        return "mikeverrelli11.png"

    if name.startswith("MILLS"):
        return "mills.png"

    if name == "MR. WRENCH":
        return "mr-wrench.png"

    if name == "PETER":
        return "peter.png"

    if name == "PUT HIM IN THE BATHROOM":
        return "put-him-in-the-bathroom.png"

    if name == "SWATTY":
        return "swatty.png"

    if name == "WILL YOU BE MY NEIGHBOURS ?":
        return "will-you-be-my-neighbours.png"

    return ""


def fit_team_name(c, name, max_width):
    name = name.upper()

    if c.text_width(name, font = "6x8") <= max_width:
        return name

    short = name

    for maximum in range(22, 5, -1):
        candidate = name[:maximum]

        if c.text_width(candidate, font = "6x8") <= max_width:
            short = candidate
            break

    return short


# ------------------------------------------------------------
# MESSAGE SCREEN
# ------------------------------------------------------------

def draw_message(c, line1, line2 = ""):
    c.fill("black")

    c.text_center(
        line1.upper(),
        6,
        font = "6x8",
        color = "amber",
    )

    if line2:
        c.text_center(
            line2.upper(),
            19,
            font = "4x5",
            color = "white",
        )


# ------------------------------------------------------------
# TEAM ROW
# ------------------------------------------------------------

def draw_team_row(c, team, y, color):
    name = team_name(team)
    score = team_score(team)
    logo = team_logo_asset(team)

    if logo:
        c.image(
            logo,
            0,
            y,
            w = 16,
            h = 16,
        )

    name = fit_team_name(c, name, 126)

    c.text(
        name,
        19,
        y + 3,
        font = "6x8",
        color = color,
    )

    c.text(
        score,
        180,
        y + 3,
        font = "6x8",
        color = color,
        align = "right",
    )


# ------------------------------------------------------------
# MATCHUP SCREEN
# ------------------------------------------------------------

def draw_matchup(c, ctx, index):
    data = fetch_data(ctx)

    if data == None:
        draw_message(c, "FANTRAX", "NO DATA")
        return

    matchups = get_matchups(data)

    if index >= len(matchups):
        draw_message(c, "FANTRAX", "MATCHUP NOT FOUND")
        return

    matchup = matchups[index]

    away = matchup.get("away", {}) or {}
    home = matchup.get("home", {}) or {}

    c.fill("black")

    draw_team_row(
        c,
        away,
        0,
        "amber",
    )

    draw_team_row(
        c,
        home,
        16,
        "white",
    )


# ------------------------------------------------------------
# PAGES
# ------------------------------------------------------------

def matchup1(c, ctx):
    draw_matchup(c, ctx, 0)


def matchup2(c, ctx):
    draw_matchup(c, ctx, 1)


def matchup3(c, ctx):
    draw_matchup(c, ctx, 2)


def matchup4(c, ctx):
    draw_matchup(c, ctx, 3)


def matchup5(c, ctx):
    draw_matchup(c, ctx, 4)


def matchup6(c, ctx):
    draw_matchup(c, ctx, 5)


def matchup7(c, ctx):
    draw_matchup(c, ctx, 6)