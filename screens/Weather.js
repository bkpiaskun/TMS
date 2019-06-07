import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity, ListView, RefreshControl, TextInput, Image, Keyboard} from 'react-native';
import {styles} from '../styles.js'

export default class Weather extends Component<Props> {

  constructor() {
      super();
      this.state = {
        refreshing: false,
        // dataSource: ds,
        error:" ",
        result: [],
        placeholder: "Tutaj wpisz miasto",
        text:" "
      };
  }

  searchButtonPressedAction(){
    Keyboard.dismiss();
    fetch('https://api.openweathermap.org/data/2.5/weather?q='+this.state.text+'&lang=pl&APPID=6c2de2e4abd413e74b995b906e15fd74')
      .then((response) => response.json())
      .then((responseJson) => {
        if(responseJson.cod === 200){
          console.log(responseJson)
          this.setState({
            result: 
              <View style={styles.weatherResult}>
                <View style={styles.weatherResultHeader}>
                  <Text style={{alignSelf:"center", fontWeight:"bold", fontSize:22}}>{"Wyniki dla miasta "+responseJson.name + " ("+responseJson.sys.country+")"}</Text>
                </View>
                <View style={styles.weatherResultContent}>
                  <Text>Temperatura</Text><Text style={styles.weatherResultText}>{" "+Math.round((responseJson.main.temp*0.1)*100)/100}</Text>
                  <Text>Ciśnienie atmosferyczne </Text><Text style={styles.weatherResultText}>{""+responseJson.main.pressure+" hPa"}</Text>
                  <Text>Wilgotność powietrza </Text><Text style={styles.weatherResultText}>{" "+responseJson.main.humidity}</Text>
                  <Text>Temperatura maksymalna</Text><Text style={styles.weatherResultText}>{""+Math.round((responseJson.main.temp_max*0.1)*100)/100}</Text>
                  <Text>Temperatura minimalna</Text><Text style={styles.weatherResultText}>{""+Math.round((responseJson.main.temp_min*0.1)*100)/100}</Text>
                  <Text>Prędkość wiatru</Text><Text style={styles.weatherResultText}>{" "+responseJson.wind.speed+" km/h"}</Text>
                  <Text style={styles.weatherResultText}>{""+responseJson.weather[0].description}</Text>

                    <Image 
                      source={{uri:'http://openweathermap.org/img/w/'+responseJson.weather[0].icon+'.png'}}
                      style={{width:60,height:60}}
                    />
                </View>   
              </View>
            
          })

          // console.log('http://openweathermap.org/img/w/'+responseJson.weather[0].icon+'.png')
        }else{
          this.setState({
            result: <Text style={styles.errorMessage}> Nie znalazłem pogody dla danego miasta </Text>
          })
        }
      })
      .catch((error) => {
          console.log(error)
          if(error = "Network request failed"){
            this.setState({
              result: <Text style={styles.errorMessage}> Brak połączenia </Text>
            })
          }
      });
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={styles.topBoi}>
          <Text style={styles.headerText}>Pogoda dla Twojego miasta</Text>
        </View>
        <View style={styles.searchView}>
          
          <TextInput
            placeholder="Tutaj wpisz miasto"
            style={styles.searchBar}
            onChangeText={(text) => this.setState({text})}
            value={this.state.text}
          >
          </TextInput>

          <TouchableOpacity style={styles.searchButton} onPress={() => this.searchButtonPressedAction()}>
            <Text style={{color:"#FFFFFF", fontWeight:"bold"}}>Szukaj</Text>
          </TouchableOpacity>
          
        </View>
        <View style={styles.measurementView}> 
          
          {this.state.result}

        </View> 
      </View>
    );
  }
}
