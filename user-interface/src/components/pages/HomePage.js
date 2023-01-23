import React, { Component } from "react";
import welllo from '../images/mainl.png'
import welllo2 from '../images/main2.png'
import welllo3 from '../images/main3.png' 
import welllo4 from '../images/coni.png' 
import {
  fetchAccounts,
} from "../../services/Web3Service";
import Header from "./Header";

class LandingPage extends Component {
  constructor(props) {
    super(props);
    this.fetchWeb3();
  }

  componentDidMount() {
    this.fetchWeb3();
  }

  fetchWeb3 = async () => {
    const res = await fetchAccounts();
    console.log("window.web3 : ", window.web3);

    window.addEventListener("load", () => {
      // Checking if Web3 has been injected by the browser (Mist/MetaMask)
      console.log("window.web3 : ", window.web3);

      if (typeof window.web3 !== "undefined") {
        console.log("Login metamask web3");
        // Use Mist/MetaMask's provider
      } else {
        console.log("No web3? You should consider trying MetaMask!");
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      }
    });
  };

  render() {
    const web3 = window.web3;
    const myStyle= {backgroundImage: `url(${welllo4})`,
    height:'100vh'
   }
    return (
      <div style={myStyle} className='py-5'>
        {/* <Header /> */}
        <div className="LandingPage mt-4 p-4" style={{ color: "fff" }}>
          <div className="position-relative">
            <section className=" my-0" >
              {/* <div className="shape shape-style-1 shape-primary">
                <span className="span-150"></span>
                <span className="span-50"></span>
                <span className="span-50"></span>
                <span className="span-75"></span>
                <span className="span-100"></span>
                <span className="span-75"></span>
                <span className="span-50"></span>
                <span className="span-100"></span>
                <span className="span-50"></span>
                <span className="span-100"></span>
              </div> */}
              <div className="row">
                <div className="col-5">
                  <div className="container  " >
                    <div className="col px-0">
                      <div className="col-lg-7">
                        <strong style={{ marginTop: "15%", fontSize: "50px" }} className=''>
                          {" "}
                          THE GLOBAL LENDING 
                          <div className="bg-primary text-white px-3 " style={{ width: "430px" }}>
                          MARKETPLACE
                          </div>
                        </strong>
                        <div className="btn-wrapper" style={{ marginTop: "80px" }}>
                          {/* <a
                            href="#"
                            className="btn btn-info btn-icon mb-3 mb-sm-0"
                            data-toggle="scroll"
                          >
                            <span className="btn-inner--icon">
                              <i className="fa fa-calculator"></i>
                            </span>
                            <span className="btn-inner--text">Loan Calculator</span>
                          </a> */}
                          <a
                            href="/register"
                            className="btn btn-white btn-icon mb-3 mb-sm-0"
                          >
                            <span className="btn-inner--icon">
                              <i className="ni ni-money-coins"></i>
                            </span>
                            <span className="btn-inner--text">Get Started</span>
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                {/* <div className="col-6 d-md-none d-lg-block d-sm-none">
                <div id="carouselExampleSlidesOnly" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                            <img src={welllo} alt="" width={"700px"} />
                            </div>
                            <div class="carousel-item">
                            <img src={welllo2} alt="" width={"700px"} />
                            </div>
                            <div class="carousel-item">
                            <img src={welllo3} alt="" width={"700px"} />
                            </div>
                        </div>
                    </div>

                </div> */}
              </div>


            </section>
          </div>
        </div>
        <div></div>
      </div>
    );
  }
}

export default LandingPage;
