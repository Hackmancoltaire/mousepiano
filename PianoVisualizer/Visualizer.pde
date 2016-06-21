class Visualizer {
  public VisualItem[] visualItems = new VisualItem[88];
  public int delay = 25;

  Visualizer() {
  }

  void addItemWithId(VisualItem item, int itemId) {
    visualItems[itemId] = item;
  }

  void update(int itemId) {
     if (visualItems[itemId] != null) {
        visualItems[itemId].update();
     }
  }

  void ping(int itemId) {
    visualItems[itemId].ping();
  }

  void pong(int itemId) {
    visualItems[itemId].pong();
  }

  void setAllItemsInactive() {
	  for (int i=0; i < keys; i++) {
		  setItemIdActive(i, false);
	  }
  }

  void setItemIdActive(int itemId, boolean activeState) {
    if (visualItems[itemId] != null) {
      visualItems[itemId].active = activeState;
    }
  }

  boolean itemIsActive(int itemId) {
    if (visualItems[itemId] != null) {
      return visualItems[itemId].active;
    } else {
      return false;
    }
  }

  int activeItemCount() {
	  int itemCount = visualItems.length;
	  int activeItemCount = 0;

	  for (int i=0; i < itemCount; i++) {
		  if (visualItems[i].active) {
			  activeItemCount++;
		  }
	  }

	  return activeItemCount;
  }

  void clear(int someId) {
	  colorMode(RGB, 255);
	  noStroke();
	  fill(0, 0, 0, 40);
	  rect(0, 0, width, height);
  }
}
