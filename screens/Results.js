

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
      };
  }

  onRefresh = () => {
    this.setState({refreshing: true});
    fetchData().then(() => {
      this.setState({refreshing: false});
    });
  }


  componentDidMount(){
    fetch('https://intern.kluchens.eu/?action=LAST')
      .then((response) => response.json())
      .then((responseJson) => {
          this.setState({
              dataSource: ds.cloneWithRows(responseJson),
          })
      })
      .catch((error) => {
          console.error(error)
      });
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={styles.topBoi}>
          <Text style={styles.headerText}>Pomiary</Text>
        </View>

          <ListView
          style={styles.listView}
          dataSource={this.state.dataSource}
          renderRow={(rowData) =>
            <View style={styles.results}>
              <Text style={styles.resultText}>{"ID: "+rowData.ID}</Text>
              <Text style={styles.resultText}>{"Nazwa Sensora: "+rowData.Sensor_Name}</Text>
              <Text style={styles.resultText}>{"Data pomiaru: "+rowData.Timestamp_Of_Reading}</Text>
              <Text style={styles.resultText}>{"Średnia wilgotności powietrza: "+rowData.AVG_Humidity}</Text>
              <Text style={styles.resultText}>{"Maksymalna wilgotność powietrza: "+rowData.Max_Humidity}</Text>
              <Text style={styles.resultText}>{"Minimalna wilgotność powietrza: "+rowData.Min_Humidity}</Text>
              <Text style={styles.resultText}>{"Średnia temperatur: "+rowData.AVG_Temperature}</Text>
              <Text style={styles.resultText}>{"Maksymalna temperatura: "+rowData.Max_Temperature}</Text>
              <Text style={styles.resultText}>{"Minimalna temperatura: "+rowData.Min_Temperature}</Text>

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
    );
  }
}
