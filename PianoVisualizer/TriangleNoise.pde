class TriangleNoise extends VisualItem {
  int Spacing = 30;
  int XPos = 0;
  int YPos= 0;

  int boxSize = 60; 
  color[] startColors = {
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0), 
    color(1, 0)
  };

  color newColor;

  int intensity = 0;
  float decayRate = 50;
  boolean show;

  TriangleNoise(color myColor) {
    newColor = myColor;
  }

  void update() {
    colorMode(RGB);
    color[] mycolors = append(startColors, color(newColor, intensity));

    noStroke();
    for (int XPos=0; XPos<width; XPos=XPos+boxSize) {
      for (int YPos=0; YPos<screenHeight; YPos=YPos+boxSize) {
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos, YPos, XPos, YPos+Spacing, XPos+Spacing, YPos+Spacing);
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos, YPos, XPos+Spacing, YPos, XPos+Spacing, YPos+Spacing);
  
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos+boxSize/2, YPos+boxSize/2, XPos+boxSize/2, YPos+Spacing+boxSize/2, XPos+Spacing+boxSize/2, YPos+Spacing+boxSize/2);
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos+boxSize/2, YPos+boxSize/2, XPos+Spacing+boxSize/2, YPos+boxSize/2, XPos+Spacing+boxSize/2, YPos+Spacing+boxSize/2);
  
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos+boxSize/2, YPos+Spacing, XPos+Spacing+boxSize/2, YPos+Spacing, XPos+Spacing+boxSize/2, YPos);
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos+boxSize/2, YPos+Spacing, XPos+boxSize/2, YPos, XPos+Spacing+boxSize/2, YPos);

        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos, YPos+Spacing+boxSize/2, XPos+Spacing, YPos+Spacing+boxSize/2, XPos+Spacing, YPos+boxSize/2);
        fill(mycolors [int(random(mycolors.length))]);
        triangle(XPos, YPos+Spacing+boxSize/2, XPos, YPos+boxSize/2, XPos+Spacing, YPos+boxSize/2);
      }
    }

    intensity = 0;
  }

  void ping() {
    intensity = 255;
  }
}