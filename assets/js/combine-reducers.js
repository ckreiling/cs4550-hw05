/**
 * Returns a new "root" reducer function for updating nested state with the given
 * reducer functions.
 * @param {Array[Function]} reducers
 */
export default function combineReducers(reducers) {
  return function(state = "undefined", action) {
    return Object.keys(reducers).reduce((acc, reducer) => {
      acc[reducer] = reducers[reducer](state[reducer], action);
      return acc;
    }, {});
  };
}
