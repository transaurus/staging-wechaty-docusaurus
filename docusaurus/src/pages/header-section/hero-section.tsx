import React from "react";
import "./hero-section.css";

const HeroSection = () => {
  return (
    <main id="body">
      <section id="heroSection">
        <p id="heroTagLine">
          In just a few lines of code, you can have a fully featured
        </p>
        <div id="heroTagLineWrapper">
          <p id="heroTagLineEmphasis1">
            <a target="_blank"> Chatbot </a> &nbsp;!
            <a target="_blank"> &nbsp;! </a>
            &nbsp;!
          </p>
        </div>
        <p id="heroSlogan">
          {" "}
          &#123; Code less works more, that's wechaty ! &#125;{" "}
        </p>
        <img alt="Chatbot" id="heroChatbotImage" src="img/chatbot-image.webp" />
        <a href="https://wechaty.js.org/docs/">
          <button id="letsDiveInButton"> Let’s Dive In</button>
        </a>
        <div id="heroExtraButtons">
          <a href="https://preangel.ai" target="_blank">
            <button className="heroSecondaryButton"> PreAngel.AI </button>
          </a>
          <a href="https://ship.fail" target="_blank">
            <button className="heroSecondaryButton"> Ship.Fail </button>
          </a>
        </div>
        <img
          alt="Chatbot"
          id="heroImageMobile"
          src="img/chatbot-image-mobile.webp"
        />
      </section>
    </main>
  );
};

export default HeroSection;
