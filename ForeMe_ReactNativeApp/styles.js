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

  actionButtonItemsIcons:{
    fontSize: 20,
    height: 22,
    color:"#FFFFFF"
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
    flex:6,
    backgroundColor:"#6f0765",
  },

  drawerButton:{
    margin:30,
    marginBottom:5,
    height:70,
    backgroundColor:'#FFFFFF',
    borderColor:'#000000',
    borderRadius:5,
    borderWidth:5,
    alignItems:'center',
    justifyContent:'center'
  },

  drawerButtonText:{
    fontWeight: "bold",
    fontStyle:"italic",
    fontFamily: "SourceSansPro-Black",
    color:'#000000',
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
  },

  // ----------------------------------------------------------  Authors ---------------------------------------------------------- 

  authorsView:{
    backgroundColor:'#ff7c37',
    flex:7,
    alignItems:'flex-start',
    justifyContent:'space-between',
    padding:20
  },

  forEachAuthor:{
    flexDirection:'row',
    alignItems:'center',
    justifyContent:'space-between',
    alignContent:'stretch',
  }, 
   
})
