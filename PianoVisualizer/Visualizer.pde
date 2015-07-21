class Visualizer {
  public VisualItem[] visualItems = new VisualItem[88];

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
}

