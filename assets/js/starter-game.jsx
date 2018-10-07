import React from "react";
import ReactDOM from "react-dom";

import Card from "./card";
import GameClient from "./game-client";
import stateReducer from "./state-reducer";

export default function game_init(root) {
  ReactDOM.render(<App />, root);
}

class App extends React.Component {
  constructor(props) {
    super(props);

    this.reset = this.reset.bind(this);
    this.tileClicked = this.tileClicked.bind(this);
    this.dispatch = this.dispatch.bind(this);

    this.client = new GameClient(this.dispatch, window.gameName);
    this.state = {
      gameId: window.gameName
    };
  }

  // Connecting function between the client and this component's state.
  dispatch({ payload, type }) {
    if (!payload || !type) {
      console.error(
        "Payload or type are not present in the dispatched action:",
        {
          payload,
          type
        }
      );
      return;
    }
    this.setState(state => stateReducer(state, { type, payload }));
  }

  // Reset the game
  reset() {
    this.client.resetCurrentGame();
  }

  // returns a function that will be called if a card is clicked.
  tileClicked(tile) {
    return () => {
      this.client.tileClicked(tile);
    };
  }

  render() {
    const { gameState, gameId } = this.state;
    return (
      (gameState && (
        <div className="app-container">
          <h2>Current game: {gameId}</h2>
          <div className="memory-container">
            {gameState.tilesRandomOrder.map(key => {
              const name = key.split("")[0];
              return (
                <Card
                  frozen={gameState.frozen}
                  key={key}
                  name={name}
                  selected={gameState[key]}
                  completed={gameState[`${name}1`] && gameState[`${name}2`]}
                  clicked={this.tileClicked(key)}
                />
              );
            })}
          </div>
          <button className="restart-button" onClick={this.reset}>
            Restart game
          </button>
          <div>Clicks in this game: {gameState.numClicks}</div>
        </div>
      )) ||
      "loading..."
    );
  }
}
