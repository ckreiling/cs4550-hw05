import combineReducers from "./combine-reducers";
import events from "./events";

function gameId(state = "", { type, payload }) {
  switch (type) {
    case events.SELECT_GAME:
      return payload;
    default:
      return state;
  }
}

function gameState(state = {}, { type, payload }) {
  switch (type) {
    case events.NEW_GAME_STATE:
      return payload;
    default:
      return state;
  }
}

export default combineReducers({ gameId, gameState });
