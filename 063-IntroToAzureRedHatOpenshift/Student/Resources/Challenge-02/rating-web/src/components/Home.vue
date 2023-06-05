<template>
  <section>
    <div class="row at-row flex-center flex-middle">
      <div class="col-lg-24">
        <a href="/"><img class="super-justice" :src="headerImage"></a>
      </div>
    </div>
    <div class="row at-row flex-center flex-middle">
      <div class="col-lg-24">
        <h1 class="super-header">{{subtitle}}</h1>
      </div>
    </div>
    <div class="row at-row flex-center flex-middle">
      <div class="col-lg-3">
      </div>
      <div class="col-lg-6">
        <at-button @click="link('Rating')" icon="icon-star" class="mid-btn" type="primary"  hollow>Start Rating</at-button>
      </div>
      <div class="col-lg-6">
        <at-button @click="link('Leaderboard')" icon="icon-bar-chart-2" class="mid-btn" type="success" hollow>View Leaderboard</at-button>
      </div>
      <div class="col-lg-6">
        <a href="https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-web" target="_blank"><at-button icon="icon-github" class="mid-btn" type="info" hollow>Clone This Code</at-button></a>
      </div>
      <div class="col-lg-3">
      </div>
    </div>
    <div class="row at-row flex-center flex-middle">
      <div class="col-lg-24">
      </div>
      </div>
  </section>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      headerImage: "",
      subtitle: "",
      errors: []
    };
  },
  created() {
    axios.get("/api/sites/" + process.env.SITE_CODE)
      .then(response => {
        var page = response.data.payload.pages.Home
        document.title = page.title
        this.headerImage = page.headerImage
        this.subtitle = page.subtitle
      }).catch(e => {
        this.errors.push(e)
      })
  },
  methods: {
    link(rel) {
      this.$router.push({ name: rel });
    }
  }
};
</script>