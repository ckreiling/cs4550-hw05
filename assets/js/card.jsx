import React from "react";

export default function Card({ selected, name, completed, clicked, frozen }) {
  if (completed) {
    return (
      <button disabled className="button-disabled green-background memory-card">
        {name}
      </button>
    );
  } else if (selected) {
    return (
      <button disabled className="button-outline memory-card">
        {name}
      </button>
    );
  } else {
    return (
      <button
        className="memory-card"
        onClick={frozen ? () => console.log("game is frozen....") : clicked}
        disabled={frozen}
      >
        ?
      </button>
    );
  }
}
