<template>
  <div class="container-fluid">
    <div class="app">
      <router-view name="main"></router-view>
      <router-view name="footer"></router-view>
    </div>
  </div>
</template>

<script>
export default {
  name: "app"
};
</script>

<style lang="scss">
@import url("https://fonts.googleapis.com/css?family=Bangers|Permanent+Marker|Graduate:400,700");


// main css
body {
  background-color: #999;
  --azure-blue: #0071c5;
  --msft-green: #4e7200;
  --msft-orange: #c72b00;
  line-height: 1;
}

html {
  line-height: 1;
}

.at-notification {
  position: fixed;
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  right: 16px;
  width: 320px;
  padding: 8px 16px;
  font-family: "Graduate", sans-serif;
  background-color: #444;
  line-height: 1.5;
  border-radius: 0px;
}

.at-notification__title {
  color: #fff;
  font-size: 13px;
}

.at-notification__message {
  color: #fff;
  font-size: 12px;
  margin-top: 4px;
}

.container-fluid {
  width: 85%;
  display: flex;
  justify-content: center;
  align-items: left;
  font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", Helvetica,
    "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial,
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.credits {
  font-family: "Graduate", sans-serif;
  font-size: 16px;
  color: #fff;
}

.credits-black {
  font-family: "Graduate", sans-serif;
  font-size: 16px;
  color: #000;
}

.credits-tag {
  padding-top: 40px;
  padding-bottom: 10px;
}
.credits-other {
  padding-bottom: 10px;
}

.footspace {
  margin-top: 90px;
  border-color: #ccc;
}

.app {
  width: 85%;
  color: #fff;
  margin-top: 30px;
  text-align: left;
}

h1,
h2 {
  font-weight: normal;
  margin: 16px 0;
}

h3,
h4 {
  text-align: left;
}
// 

// .at-related
.at-card {
  margin-bottom: 10px;
}

.at-card__head {
  background-color: #2d2d2d;
}

.at-card__body {
  background-color: #444;
}

.at-rate {
  padding-top: 12px;
}

.at-rate__icon {
  position: relative;
  text-shadow: 2px 2px 6px #111;
}

.at-rate__left {
  text-shadow: none;
}

.at-btn--primary:hover {
  color: var(--azure-blue);
  border: 2px solid var(--azure-blue);
}

.at-btn--success:hover {
  color: var(--msft-green);
  border: 2px solid var(--msft-green);
}

.at-btn--info:hover {
  color: var(--msft-orange);
  border: 2px solid var(--msft-orange);
}

.at-btn {
  color: #fff;
  border: 2px solid #fff;
  border-radius: 0px;
}

.at-btn__text {
  font-family: "Bangers", cursive;
  font-size: 22px;
  font-weight: 100;
  padding-left: 2px;
}

.at-btn__icon {
  font-size: 20px;
}
// end .at-related

// rate-related
.rate-submit {
  margin-top: 40px;
}

.rate-submit .at-btn__text {
  font-size: 36px;
}

.rate-submit .at-btn__icon {
  font-size: 36px;
}

.rate-submit.at-btn--default:hover {
  color: var(--msft-green);
  border-color: var(--msft-green);
}

.mid-btn {
  width: 240px;
}
// end rate-related

// super-related
.super-justice {
  height: 240px;
}

.super-header {
  color: #fff;
  font-size: 36px;
  font-family: "Permanent Marker", cursive;
}

.super-image {
  -webkit-filter: drop-shadow(3px 3px 3px #111);
  filter: drop-shadow(3px 3px 3px #111);
  width: 100%;
}

.super-name {
  font-size: 24px;
  color: #fff;
  font-family: "Bangers", cursive;
  font-weight: 100;
  text-shadow: 4px 4px 6px #000;
}

.super-name-lead {
  font-size: 48px;
  font-family: "Bangers", cursive;
  font-weight: 100;
  text-shadow: 4px 4px 6px #000;
}

.super-name-first {
  color: rgb(25, 255, 25);
}

.super-name-else {
  color: rgb(251, 255, 6);
}

.super-name-last {
  color: rgb(255, 21, 21);
}

.super-rate-foot {
  text-align: center;
}

.super-star-text-shell .at-rate__icon {
  padding-top: 7px;
  color: rgb(255, 254, 198);
  text-shadow: 4px 4px 6px #000;
}

.super-star-total-shell {
  border: 1px solid #777;
  background-color: #333;
  padding: 10px 8px 8px 8px;
}

.super-star-total-rate {
  border: 1px solid #646464;
  background-color: #484848;
  padding: 0 0 10px 0;
}

.super-star-text {
  padding-left: 4px;
  padding-right: 6px;
  font-size: 16px;
  color: #ccc;
  font-family: "Bangers", cursive;
  font-weight: 100;
  text-shadow: 2px 2px 1px #000;
}

.super-star-text-totals {
  font-size: 18px;
  color: #fff;
  font-family: "Bangers", cursive;
}

.super-vote {
  padding: 80px;
}

.pad4 {
  padding: 4px;
}

.padbottom10 {
  padding-bottom: 10px;
}
// end super-related

</style>
