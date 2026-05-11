//AI KEY
String AI_KEY = "AIzaSyDMhs23JKBSC-BdUCACMvxB-NknF3fNtaI";

//File này cho phép tinh chỉnh dữ liệu của api daotap.vnua.edu.vn
//Địa chỉ gốc
String APIDAOTAO = "https://daotao.vnua.edu.vn/api";

//Api đăng nhập
String APIAUTH = "$APIDAOTAO/auth/authconfig";
String APILOGIN(final code) {
  return "https://daotao.vnua.edu.vn/api/pn-signin?code=$code&gopage=&mgr=1";
}

String APISCHEDURE = "/sch/w-locdstkbtuanusertheohocky"; //Api Thời khóa biểu
String APIREGISTER = "";
String APISCOREDATA =
    "/srm/w-locdsdiemsinhvien?hien_thi_mon_theo_hkdk=false"; //Api điểm
String APINOTIFICATION = "/web/w-locdsthongbao"; //api notification
String APIINFORMATION = "/dkmh/w-locsinhvieninfo"; //api thông tin sinh viên
String APITUITON = "/rms/w-locdstonghophocphisv"; //api học phí
String APITRAININGPROGRAM = "/sch/w-locdsctdtsinhvien"; //api chuong trinh dao tao