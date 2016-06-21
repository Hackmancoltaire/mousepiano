class Tweet {
  PImage avatar;
  String username;
  String content;
  float x, y;
  
  int boxWidth = 300;
  int boxHeight = 100;

  int avatarWidth = 50;
  int avatarHeight = 50;
  
  int border = 10;
  
  int fadeDelay = 400;
  int intensity = 0;
  int decayRate = 1;
  
  PFont usernameFont = createFont("Helvetica Bold", 12);
  PFont contentFont = createFont("Helvetica", 12);
  
  Tweet(String html) {
    x = 0;
    y = 0;

    // println(html);

    // Username
    int start = html.indexOf("<b>");
    int end = html.indexOf("</b>");
    username = html.substring(start+3, end);
    
    // println("Username: " + username); 

    // Content
    start = html.indexOf("<br>");
    end = html.indexOf("<br>", start+4);
    content = html.substring(start+4, end);

    // println("Content: " + content); 

    // Pull out Avatar
    start = html.indexOf(",");
    end = html.indexOf('"', start);
    String baseData = html.substring(start, end);

    try {
      avatar = DecodePImageFromBase64(baseData);
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    intensity = 255;
  }

  void setPosition(int newX, int newY) {
    x = newX;
    y = newY;
  }

  void draw() {
    noStroke();

    fill(255, 255, 255, intensity-50);
    rect(x, y, boxWidth, boxHeight, 10);

    fill(0, 0, 0, intensity);
    textAlign(LEFT);
    
    textFont(usernameFont);
    text(username, x+border+border+avatarWidth, y+border, boxWidth-avatarWidth-(border * 3), 15);
    
    textFont(contentFont);
    text(content, x+border+border+avatarWidth, y+(border + 20), boxWidth-avatarWidth-(border * 3), boxHeight-20);

    tint(255, intensity);
    image(avatar, x+10, y+10, avatarWidth, avatarHeight);

    if (fadeDelay <= 0) {
  
      if (intensity < 0) {
        intensity = 0;
      } else {
        intensity -= decayRate;
      }
    } else {
     fadeDelay -= 1; 
    }
  }
}