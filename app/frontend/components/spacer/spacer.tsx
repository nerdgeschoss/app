import "./spacer.scss";

import React from "react";
import classnames from "classnames";

interface Props {
  size?: number;
  tabletSize?: number;
  desktopSize?: number;
  horizontal?: boolean;
  display?: "mobile" | "tablet" | "desktop";
}

export function Spacer({
  size = 24,
  tabletSize,
  desktopSize,
  horizontal,
  display = "mobile",
}: Props): JSX.Element {
  return (
    <hr
      className={classnames(
        "spacer",
        `spacer--${size}`,
        tabletSize ? `spacer--tablet-${tabletSize}` : "",
        desktopSize ? `spacer--desktop-${desktopSize}` : "",
        display && `spacer--display-${display}`,
        {
          "spacer--horizontal": horizontal,
        },
      )}
      style={
        {
          "--size": `${size}px`,
          "--tablet-size": `${tabletSize || size}px`,
          "--desktop-size": `${desktopSize || tabletSize || size}px`,
        } as React.CSSProperties
      }
    />
  );
}
