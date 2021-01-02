import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, ScrollView, TouchableOpacity, Image} from 'react-native';

import {styles} from '../styles.js'

export class QuizButt extends Component {
  render(){
    return (
      <TouchableOpacity onPress={this.props.func} style={styles.chooseQuizButt}>
        <Text style={styles.title}>{this.props.title}</Text>
        <Text style={styles.p}>{this.props.content}</Text>
        <Text style={styles.p}>{"Pozią: " + this.props.difficulty}</Text>
        <Text style={styles.p}>{"Ilość pytań" + this.props.numberOfTasks}</Text>
      </TouchableOpacity>
    )
  }
}

export class Butt extends Component {
  render(){
    return (
      <TouchableOpacity onPress={this.props.func} style={styles.chooseQuizButt}>
        <Text style={styles.title}>{this.props.title}</Text>
      </TouchableOpacity>
    )
  }
}
