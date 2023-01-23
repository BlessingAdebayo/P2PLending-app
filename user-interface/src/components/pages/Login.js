import React, { useState } from "react";
import axios from "axios";
import { Link } from "react-router-dom";
import Navbar from "./Navbar";
import welllo4 from '../images/coni.png'

const defaultForm = {
  email: "",
  password: ""
};
export default function (props) {
  const {
    history: { push }
  } = props;

  const [error, setError] = useState(null);
  const [form, setForm] = useState(defaultForm);

  const updateForm = (key, value) => {
    if (!key || !formKeys[key]) {
      throw new Error("Invalid form key set");
    }
    // Reset the error
    error && setError(null);
    setForm({ ...form, [key]: value });
  };

  const formKeys = Object.keys(form)
    .map(key => key)
    .reduce((acc, val) => {
      acc[val] = val;
      return acc;
    }, {});

  const checkValidity = () => {
    for (const key in form) {
      const val = form[key];
      if (typeof val === "string") {
        if (!val || val === "" || val.length === 0) return false;
      }

      if (typeof val === "object") {
        if (Object.keys(val).length < 0) return false;
      }
    }

    return true;
  };

  const handleLogin = async () => {
    // Request API.
    try {
      const response = await axios.post(
        "https://www.cipherfit.com/auth/local",
        {
          identifier: form.email,
          password: form.password
        }
      );

      console.log("Well done!");
      window.localStorage.setItem("user", response.data.user.username);
      window.localStorage.setItem("jwt", response.data.jwt);
      window.localStorage.setItem(
        "companyName",
        response.data.user.companyName
      );
      push("/myloans");
    } catch (err) {
      if (
        err.response &&
        err.response.data &&
        typeof err.response.data.message === "string"
      ) {
        setError(err.response.data.message);
      } else {
        setError(
          "Sorry we couldn't complete your registration. Please contact us!"
        );
      }
    }
  };
  const myStyle = {
    backgroundImage: `url(${welllo4})`,
    height: '100vh'
  }
  return (
    <>
      <Navbar />
      <div
        className="header py-7 py-lg-8 pt-lg-9 "
        style={myStyle}

      >
        <div className="container">
          <div className="header-body text-center mb-7">
            <div className="container mt--3 pb-5">
              <div className="row justify-content-center">
                <div className="col-lg-6 col-md-10" style={{ border: "2px solid powderblue", margin: '2%', borderRadius: '20px' }}>
                  <div className="card bg-transparent border-0 mb-0">
                    <div className="card-header bg-transparent">
                      <h4 className="text-white text-center mt-2 mb-3 fw-bold ">
                        Sign In
                      </h4>
                    </div>
                    <div className="card-body px-lg-5 py-lg-3">
                      <div className="text-center text-white mb-4">
                        Enter your login details.
                      </div>
                      <form
                        onSubmit={e => {
                          e.preventDefault();
                          checkValidity() && handleLogin();
                        }}
                      >
                        <div className="form-group mb-3">
                          <div className="input-group input-group-merge input-group-alternative" style={{ border: '2px solid powderblue', borderRadius: '10px' }}>
                            <div className="input-group-prepend">
                              <span className="input-group-text bg-transparent">
                                <i className="ni ni-email-83"></i>
                              </span>
                            </div>
                            <input
                              className="form-control bg-transparent text-white"
                              style={{ marginTop: 0 }}
                              placeholder="Email"
                              type="email"
                              value={form.email}

                              onChange={e => {
                                updateForm(formKeys.email, e.target.value);
                              }}
                              required
                            />
                          </div>
                        </div>
                        <div className="form-group">
                          <div className="input-group input-group-merge input-group-alternative" style={{ border: '2px solid powderblue', borderRadius: '5px' }}>
                            <div className="input-group-prepend">
                              <span className="input-group-text bg-transparent">
                                <i className="ni ni-lock-circle-open"></i>
                              </span>
                            </div>
                            <input
                              className="form-control bg-transparent text-white"
                              style={{ marginTop: 0 }}
                              placeholder="Password"
                              type="password"
                              value={form.password}

                              onChange={e => {
                                updateForm(formKeys.password, e.target.value);
                              }}
                              required
                            />
                          </div>
                        </div>
                        <div className="custom-control custom-control-alternative custom-checkbox">
                          <input
                            className="custom-control-input"
                            id=" customCheckLogin"
                            type="checkbox"
                          />
                          <label
                            className="custom-control-label"
                            for=" customCheckLogin"
                          >
                            <span className="text-white">Remember me</span>
                          </label>
                        </div>
                        {error && (
                          <small className="text-danger d-block mt-4 text-center">
                            {error}
                          </small>
                        )}

                        <div className="text-center">
                          <button
                            type="submit"
                            style={{ backgroundColor: '#E2AC49' }}
                            className={`btn mt-5 w-50 ${checkValidity() ? "" : "disabled"
                              }`}
                          >
                            Sign in
                          </button>
                        </div>
                      </form>
                    </div>
                  </div>
                  <div className="row my-5 ">
                    <div className="col-6 text-left">
                      <a className="text-white my-3" style={{cursor: 'pointer'}} data-bs-toggle="modal" data-bs-target="#exampleModal">
                        <small>Forgotten password?</small>
                      </a>
                      {/* Button trigger modal */}
                      {/* <button type="button"  >
                      Forgot password?
                      </button> */}
                    </div>

                    <div className="col-6 text-right">
                      <Link to="/register" className="text-white my-5 ">
                        <small>Create new account</small>
                      </Link>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/*  Modal */}
      <div className="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div className="modal-dialog modal-dialog-centered">
          <div className="modal-content">
            <div className="modal-header">
              <h1 className="modal-title fs-5" id="exampleModalLabel">Forgot Password?</h1>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div className="modal-body">
              <div className="form-group mb-3">
                <div className="input-group input-group-merge input-group-alternative" style={{ border: '2px solid powderblue', borderRadius: '10px' }}>
                  <div className="input-group-prepend">
                    <span className="input-group-text bg-transparent">
                      <i className="ni ni-email-83"></i>
                    </span>
                  </div>
                  <input
                    className="form-control bg-transparent text-white"
                    style={{ marginTop: 0 }}
                    placeholder="Email"
                    type="email"
                    value={form.email}

                    onChange={e => {
                      updateForm(formKeys.email, e.target.value);
                    }}
                    required
                  />
                </div>
              </div>
              <div className="form-group">
                          <div className="input-group input-group-merge input-group-alternative" style={{ border: '2px solid powderblue', borderRadius: '5px' }}>
                            <div className="input-group-prepend">
                              <span className="input-group-text bg-transparent">
                                <i className="ni ni-lock-circle-open"></i>
                              </span>
                            </div>
                            <input
                              className="form-control bg-transparent text-white"
                              style={{ marginTop: 0 }}
                              placeholder=" New Password"
                              type="password"
                              value={form.password}

                              onChange={e => {
                                updateForm(formKeys.password, e.target.value);
                              }}
                              required
                            />
                          </div>
                        </div>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">Back</button>
              <button type="button" className="btn btn-primary">Save changes</button>
            </div>
          </div>
        </div>
      </div>

    </>
  );
}
