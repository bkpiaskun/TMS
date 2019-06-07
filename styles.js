import {StyleSheet} from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
    alignItems: 'stretch'
  },
  splash: {
    alignItems: 'center',
    alignContent: 'center',
    flex: 1,
    backgroundColor: '#ffd69e',
  },
  splashHolder:{
    flex: 7,
    backgroundColor: '#ff7c38',
    justifyContent:'center',
    alignItems:'center'
  },
  logo:{
    width:200,
    height:200,
    padding:20,
    resizeMode:'contain'
  },
  scrollContainer: {
    backgroundColor: '#71c9ce',
  },
  title: {
    fontWeight: "bold",
    fontFamily: "SourceSansPro-Black",
    color:'#FFFFFF',
  },
  p: {
    fontSize: 14
  },
  topBoi: {
    justifyContent:'center',
    alignItems: 'center',
    fontSize: 20,
    backgroundColor: '#e03e36',
    flex:1,
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
    width:300,
    borderColor: '#FFFFFF',
    backgroundColor:'#eb5000',
    borderWidth: 3,
    borderRadius: 20,
    alignItems:'center'
  },
  listView:{
    flex:1
  },
  results:{
    borderWidth:2,
    borderColor:'#700961',
    borderRadius:5,
    backgroundColor:"#b80d57",
    margin:15,
    padding:15,
  },

  resultText:{
    color:'rgb(255,255,255)',
    fontSize:15,
    fontFamily:"SourceSansPro-Black",
    letterSpacing:1
  },

  measurementView:{
    backgroundColor:'#ff7c37',
    flex:7,
  },

  // ---------------------------------------------------------- Drawer special ---------------------------------------------------------- 

  drawerMainContainer:{
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
    backgroundColor: '#FFFFFF',
  },

  drawerHeader:{
    flex:2,
    padding:10,
    justifyContent: 'center',
    alignItems: 'center',
    flexDirection:'row',
    backgroundColor:"#4c0045",
  },

  drawerButtons:{
    paddingRight:50,
    flex:6,
    backgroundColor:"#6f0765",
    paddingBottom:20,
  },

  drawerButton:{
    marginTop:30,
    marginLeft: 0,
    height:70,
    backgroundColor:'#76C43F',
    borderBottomRightRadius:50,
    borderColor:'#1F4B00',
    borderWidth:2,
    borderLeftWidth:0,
    alignItems:'center',
    justifyContent:'center'
  },

  drawerButtonText:{
    fontWeight: "bold",
    fontFamily: "SourceSansPro-Black",
    color:'#FFFFFF',
    fontSize:25,
  },

  drawerHeaderText:{
    color:"white",
    margin:20,
    fontSize:30,
    fontFamily:'Pacifico-Regular'
  },

  drawerLogo:{
    width:100,
    height:100,
    padding:20,
    resizeMode:'contain'
  },

  // ----------------------------------------------------------  Other stuff ---------------------------------------------------------- 

  errorMessage:{
    fontWeight:'bold',
    color:'#FFFFFF',
    margin:10,
    padding:10,
    fontSize:20,
    alignSelf:'center'
  },

  // ----------------------------------------------------------  OpenWeatgerMap ---------------------------------------------------------- 

  searchView:{
    backgroundColor:'#ff7c37',
    flexDirection: "row",
    alignContent:"stretch",
    padding:5,
    paddingTop:10
  },

  searchButton:{
    justifyContent:"center",
    alignItems:"center",
    flex:1,
    borderColor:"white",
    borderWidth:1,
    backgroundColor:"#990011",
    borderRadius:5
  },

  searchBar:{
    flex:5,
    marginRight:5,
    backgroundColor:"white",
    borderRadius:5,
    borderColor:"#990011",
    borderWidth:1
  },

  weatherResult:{
    borderWidth:4,
    borderColor:'#700961',
    borderRadius:5,
    backgroundColor:"#FFF5EE",
    margin:15,
    flex:1
  },

  weatherResultText:{
    color:'#000000',
    fontSize:15,
    fontFamily:"SourceSansPro-Black",
    letterSpacing:1,
    paddingBottom:5
  },

  weatherResultHeader:{
    borderBottomWidth:1,
    backgroundColor:"#FFFFFF",
    alignItems:"center",
    justifyContent:"center",
    flex:1
  },

  weatherResultContent:{
    alignItems:"center",
    justifyContent:"center",
    flex:5
  }
})
