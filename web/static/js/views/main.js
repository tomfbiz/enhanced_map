export default class MainView {
  mount() {
    //  This will be executed when the document loads...
    document.getElementsByClassName("logout-link")[0].onclick = () => {
      let xhttp = new XMLHttpRequest();
      xhttp.open("DELETE","/logout",true);
      xhttp.send();
    };
  }
}
