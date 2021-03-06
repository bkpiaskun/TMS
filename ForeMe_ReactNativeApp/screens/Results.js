import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity, ListView, RefreshControl} from 'react-native';
import {styles} from '../styles.js'
type Props = {};
const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});

export default class Results extends Component<Props> {

  constructor() {
      super();
      this.componentDidMount;
      this.state = {
        refreshing: false,
        dataSource: ds,
        error:" "
      };
  }

  _onRefresh = () => {
    this.setState({refreshing: true});
    fetch('https://intern.kluchens.eu?action=MyLasts&UserName=piaskunbk&ApiKey=0')
    .then((response) => response.json())
      .then((responseJson) => {
          this.setState({
              dataSource: ds.cloneWithRows(responseJson),
          })
      })
      .catch((error) => {
          if(error = "Network request failed"){
            fetch('http://intern.kluchens.eu?action=MyLasts&UserName=piaskunbk&ApiKey=0')
            .then((response) => response.json())
              .then((responseJson) => {
                  this.setState({
                      dataSource: ds.cloneWithRows(responseJson),
                  })
              })
              .catch((error) => {
                  if(error = "Network request failed"){
                          if(error = "Network request failed"){
                            this.setState(
                              { error:"Oops! Wystąpił problem. Spróbuj jeszcze raz" }
                              )
                          };
                    }
                  }
              )
            }
          }
      ).then(() => {
      this.setState({refreshing: false});
    });
    
  }


  componentDidMount(){
    fetch('https://intern.kluchens.eu?action=MyLasts&UserName=piaskunbk&ApiKey=0')
    .then((response) => response.json())
      .then((responseJson) => {
          this.setState({
              dataSource: ds.cloneWithRows(responseJson),
          })
      })
      .catch((error) => {
          if(error = "Network request failed"){
            fetch('http://intern.kluchens.eu?action=MyLasts&UserName=piaskunbk&ApiKey=0')
            .then((response) => response.json())
              .then((responseJson) => {
                  this.setState({
                      dataSource: ds.cloneWithRows(responseJson),
                  })
              })
              .catch((error) => {
                  if(error = "Network request failed"){
                          if(error = "Network request failed"){
                            this.setState(
                              { error:"Oops! Wystąpił problem. Spróbuj jeszcze raz" }
                              )
                          };
                    }
                  }
              )
            }
          }
      )
    };


  render() {
    return (
      <View style={styles.container}>
        <View style={styles.topBoi}>
          <Text style={styles.headerText}>Pomiary</Text>
        </View>
        <View style={styles.measurementView}> 
          <Text style={styles.errorMessage}> {this.state.error}</Text>
          <ListView
            style={styles.listView}
            dataSource={this.state.dataSource}
            renderRow={(rowData) =>
              <View style={styles.results}>
                <Text style={styles.resultText}>{"Nazwa Sensora: "+rowData.Sensor_Name}</Text>
                <Text style={styles.resultText}>{"Data pomiaru: "+rowData.Timestamp_Of_Reading}</Text>
                <Text style={styles.resultText}>{"Średnia wilgotności powietrza: "+rowData.AVG_Humidity}</Text>
                <Text style={styles.resultText}>{"Średnia temperatur: "+rowData.AVG_Temperature}</Text>
              </View>
            }

              refreshControl={
                <RefreshControl
                  refreshing={this.state.refreshing}
                  onRefresh={this._onRefresh}
                />
              }
            />
        </View> 
      </View>
    );
  }
}
