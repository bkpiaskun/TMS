import {StyleSheet} from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: 'rgb(41,48,70)',
    alignItems: 'stretch'
  },
  splash: {
    alignItems: 'center',
    alignContent: 'center',
    flex: 1,
    backgroundColor: '#ffd69e',
  },
  splashHolder:{
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1
  },
  logo:{
    width: 200,
    height: 200
  },
  scrollContainer: {
    backgroundColor: '#ffd69e',
  },
  title: {
    fontWeight: "bold",
    fontFamily: "SourceSansPro-Black",
    fontSize: 18
  },
  p: {
    fontSize: 14
  },
  topBoi: {
    alignItems: 'center',
    backgroundColor: 'rgb(139, 152, 201)',
    borderBottomColor: 'rgb(78, 88, 125)',
    borderBottomWidth: 2
  },
  headerText: {
    fontSize: 24,
    padding: 9,
    color:"#FFFFFF",
    fontFamily: "SourceSansPro-Black",
  },
  chooseQuizButt: {
    margin: 16,
    padding: 12,
    borderColor: '#755934',
    borderWidth: 1,
    alignItems: 'center',
  },
  listView:{
  marginTop:20,
},

results:{
  borderWidth:2,
  borderColor:'rgb(78, 88, 125)',
  borderRadius:5,
  backgroundColor:"rgb(139, 152, 201)",
  margin:15,
  padding:15,
},

resultText:{
  color:'rgb(255,255,255)',
  fontSize:15,
  fontFamily:"SourceSansPro-Black",
  letterSpacing:1
}

})
