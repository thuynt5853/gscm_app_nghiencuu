using BL.GSTP.GSTP;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.Thongtinchitietcanbo.SoYeuLyLich
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private ReportDataSource rds;
        RootObject objSYLL = new RootObject();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadReport();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadReport()
        {
            decimal ThamPhanID = string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_GSTP] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
            string MaCanBo = "", MaDongBo = "";
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault<DM_CANBO>();
            if (cbo != null)
            {
                MaCanBo = cbo.MACANBO;
                MaDongBo = cbo.MADONGBO;
            }
            if (MaDongBo != "")
            {
                string DataSetName = "DataSetSoYeuLyLich", reportName = "SoYeuLyLich.rdlc";
                objSYLL = GetDataSoYeuLyLich(MaDongBo);
                String path = "~/BaoCao/GSTP/" + reportName;
                if (objSYLL != null)
                {
                    #region Kiểm tra và gán dữ liệu
                    Profile pr = objSYLL.d.data[0].profile[0];
                    string FULLNAME = pr.FULLNAME + "" == "" ? "" : pr.FULLNAME.ToUpper(),
                        sinhNgay = pr.BIRTH_DAY + " tháng " + pr.BIRTH_MONTH + " năm " + pr.BIRTH_YEAR,
                        GioiTinh = pr.GENDER, NoiSinh = pr.BIRTH_PLACE + "" == "" ? "" : pr.BIRTH_PLACE,
                        NoiSinhTinh = "", NoiSinhHuyen = "", NoiSinhXa = "",
                        QueQuan = pr.NAV_ADDRESS, QueQuanTinh = "", QueQuanHuyen = "", QueQuanXa = "";
                    int Length = 0;
                    if (NoiSinh != "")
                    {
                        string[] arrNoiSinh = NoiSinh.Split(',');
                        Length = arrNoiSinh.Length;
                        if (Length == 1)
                        {
                            NoiSinhTinh = arrNoiSinh[0] + "" == "" ? "" : arrNoiSinh[0].ToString();
                        }
                        else if (Length == 2)
                        {
                            NoiSinhHuyen = arrNoiSinh[0] + "" == "" ? "" : arrNoiSinh[0].ToString();
                            NoiSinhTinh = arrNoiSinh[1] + "" == "" ? "" : arrNoiSinh[1].ToString();
                        }
                        else
                        {
                            NoiSinhXa = arrNoiSinh[0] + "" == "" ? "" : arrNoiSinh[0].ToString();
                            NoiSinhHuyen = arrNoiSinh[1] + "" == "" ? "" : arrNoiSinh[1].ToString();
                            NoiSinhTinh = arrNoiSinh[2] + "" == "" ? "" : arrNoiSinh[2].ToString();
                        }
                    }
                    if (QueQuan != "")
                    {
                        string[] arrQueQuan = QueQuan.Split(',');
                        Length = arrQueQuan.Length;
                        if (Length == 1)
                        {
                            QueQuanTinh = arrQueQuan[0] + "" == "" ? "" : arrQueQuan[0].ToString();
                        }
                        else if (Length == 2)
                        {
                            QueQuanHuyen = arrQueQuan[0] + "" == "" ? "" : arrQueQuan[0].ToString();
                            QueQuanTinh = arrQueQuan[1] + "" == "" ? "" : arrQueQuan[1].ToString();
                        }
                        else
                        {
                            QueQuanXa = arrQueQuan[0] + "" == "" ? "" : arrQueQuan[0].ToString();
                            QueQuanHuyen = arrQueQuan[1] + "" == "" ? "" : arrQueQuan[1].ToString();
                            QueQuanTinh = arrQueQuan[2] + "" == "" ? "" : arrQueQuan[2].ToString();
                        }
                    }

                    #endregion
                    List<ReportParameter> parms = new List<ReportParameter>();
                    #region ReportParameter
                    parms.Add(new ReportParameter("ORG_NAME", pr.ORG_NAME));
                    parms.Add(new ReportParameter("MaCanBo", MaCanBo));
                    parms.Add(new ReportParameter("ORG_CHILD_NAME2", pr.ORG_CHILD_NAME2));
                    parms.Add(new ReportParameter("FULLNAME", FULLNAME));
                    parms.Add(new ReportParameter("OTHER_NAME", pr.OTHER_NAME));
                    parms.Add(new ReportParameter("BIRTH_PLACE_Tinh", NoiSinhTinh));
                    parms.Add(new ReportParameter("BIRTH_PLACE_Huyen", NoiSinhHuyen));
                    parms.Add(new ReportParameter("BIRTH_PLACE_Xa", NoiSinhXa));
                    parms.Add(new ReportParameter("NAV_ADDRESS_Tinh", QueQuanTinh));
                    parms.Add(new ReportParameter("NAV_ADDRESS_Huyen", QueQuanHuyen));
                    parms.Add(new ReportParameter("NAV_ADDRESS_Xa", QueQuanXa));
                    parms.Add(new ReportParameter("NATIVE_NAME", pr.NATIVE_NAME));

                    parms.Add(new ReportParameter("RELIGION_NAME", pr.RELIGION_NAME));
                    parms.Add(new ReportParameter("PER_ADDRESS", pr.PER_ADDRESS));
                    parms.Add(new ReportParameter("CUR_ADDRESS", pr.CUR_ADDRESS));
                    parms.Add(new ReportParameter("JOB_BEFORE", pr.JOB_BEFORE));
                    parms.Add(new ReportParameter("JOIN_DATE", pr.JOIN_DATE));
                    parms.Add(new ReportParameter("COMPANY_CONG_CHUC", pr.COMPANY_CONG_CHUC));
                    parms.Add(new ReportParameter("GROUPTITLE_NAME", pr.GROUPTITLE_NAME));
                    parms.Add(new ReportParameter("POS_NAME", pr.POS_NAME));
                    parms.Add(new ReportParameter("RANK_NAME", pr.RANK_NAME));
                    parms.Add(new ReportParameter("RANK_CODE", pr.RANK_CODE));
                    parms.Add(new ReportParameter("LEVEL_NAME", pr.LEVEL_NAME));

                    parms.Add(new ReportParameter("COEFFICIENT", pr.COEFFICIENT));
                    parms.Add(new ReportParameter("SALARY_EFFECTDATE", pr.SALARY_EFFECTDATE));
                    parms.Add(new ReportParameter("TRINHDOGIAODUC_NAME", pr.TRINHDOGIAODUC_NAME));
                    parms.Add(new ReportParameter("TRINHDOCHUYENMON_NAME", pr.TRINHDOCHUYENMON_NAME));
                    parms.Add(new ReportParameter("LYLUAN_CHINHTRI", pr.LYLUAN_CHINHTRI));
                    parms.Add(new ReportParameter("QUANLY_NHANUOC", pr.QUANLY_NHANUOC));
                    parms.Add(new ReportParameter("NGOAINGU", pr.NGOAINGU));
                    parms.Add(new ReportParameter("TINHOC", pr.TINHOC));
                    parms.Add(new ReportParameter("NGAYVAODANG", pr.NGAYVAODANG));
                    parms.Add(new ReportParameter("NGAYVAODANG_CHINHTHUC", pr.NGAYVAODANG_CHINHTHUC));
                    parms.Add(new ReportParameter("THAMGIA_TCCT", pr.THAMGIA_TCCT));

                    parms.Add(new ReportParameter("NGAYNHAPNGU", pr.NGAYNHAPNGU));
                    parms.Add(new ReportParameter("NGAYXUATNGU", pr.NGAYXUATNGU));
                    parms.Add(new ReportParameter("TEN_QUANHAM_CAONHAT", pr.TEN_QUANHAM_CAONHAT));
                    parms.Add(new ReportParameter("TEN_DANHHIEU_CAONHAT", pr.TEN_DANHHIEU_CAONHAT));
                    parms.Add(new ReportParameter("SOTRUONG_CONGTAC", pr.SOTRUONG_CONGTAC));
                    parms.Add(new ReportParameter("KHENTHUONG", pr.KHENTHUONG));
                    parms.Add(new ReportParameter("KYLUAT", pr.KYLUAT));
                    parms.Add(new ReportParameter("TINHTRANGSUCKHOE", pr.TINHTRANGSUCKHOE));
                    parms.Add(new ReportParameter("CHIEUCAO", pr.CHIEUCAO));
                    parms.Add(new ReportParameter("CANNANG", pr.CANNANG));
                    parms.Add(new ReportParameter("NHOMMAU", pr.NHOMMAU));

                    parms.Add(new ReportParameter("HANGTHUONGBINH", pr.HANGTHUONGBINH));
                    parms.Add(new ReportParameter("GIADINHCHINHSACH", pr.GIADINHCHINHSACH));
                    parms.Add(new ReportParameter("CMND", pr.CMND));
                    parms.Add(new ReportParameter("NGAYCAP_CMND", pr.NGAYCAP_CMND));
                    parms.Add(new ReportParameter("SO_BHXH", pr.SO_BHXH));

                    string TuDayNoiDung = "", ThamGiaTCNuocNgoai = "";
                    if (pr.TUDAY_TUNGAY + "" != "")
                    {
                        TuDayNoiDung += "Bị bắt, bị tù từ ngày " + pr.TUDAY_TUNGAY;
                    }
                    if (pr.TUDAY_DENNGAY + "" != "")
                    {
                        TuDayNoiDung += " đến ngày " + pr.TUDAY_DENNGAY;
                    }
                    if (pr.TUDAY_ODAU + "" != "")
                    {
                        TuDayNoiDung += " ở " + pr.TUDAY_ODAU + ". ";
                    }
                    if (pr.TUDAY_NOIDUNG + "" != "")
                    {
                        TuDayNoiDung += pr.TUDAY_NOIDUNG + ".";
                    }
                    if (pr.TCNN_CONGVIEC + "" != "")
                    {
                        ThamGiaTCNuocNgoai += "Công việc:" + pr.TCNN_CONGVIEC + ". ";
                    }
                    if (pr.TCNN_TEN + "" != "")
                    {
                        ThamGiaTCNuocNgoai += "Làm việc tại:" + pr.TCNN_TEN + ". ";
                    }
                    if (pr.TCNN_TRUSO + "" != "")
                    {
                        ThamGiaTCNuocNgoai += "Địa chỉ:" + pr.TCNN_TRUSO + ". ";
                    }
                    parms.Add(new ReportParameter("TuDayNoiDung", TuDayNoiDung));
                    parms.Add(new ReportParameter("ThamGiaTCNuocNgoai", ThamGiaTCNuocNgoai));
                    parms.Add(new ReportParameter("CONHANTHAN", pr.THAN_NHAN));
                    parms.Add(new ReportParameter("DANHGIA", ""));
                    parms.Add(new ReportParameter("SinhNgay", sinhNgay));
                    parms.Add(new ReportParameter("GioiTinh", GioiTinh));
                    #endregion
                    ReportViewer1.ProcessingMode = ProcessingMode.Local;
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath(path);
                    ReportViewer1.LocalReport.ReportEmbeddedResource = "WEB.GSTP.BaoCao.GSTP." + reportName;
                    if (parms != null)
                    {
                        ReportViewer1.LocalReport.SetParameters(parms);
                    }
                    ReportViewer1.LocalReport.DataSources.Clear();
                    ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource(DataSetName, new DataTable()));
                    ReportViewer1.Visible = true;
                    ReportViewer1.LocalReport.EnableExternalImages = true;
                    ReportViewer1.LocalReport.EnableHyperlinks = true;
                    ReportViewer1.ShowReportBody = true;
                    ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(Sub_SoYeuLyLich_QHGD);
                    ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(Sub_SoYeuLyLich_QHGD_TrinhDoDaoTao);
                    ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(Sub_SoYeuLyLich_QHGD_Vo);
                    ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(Sub_SoYeuLyLich_QTCongTac);
                    ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(Sub_SoYeuLyLich_QTLuong);
                    ReportViewer1.LocalReport.Refresh();
                    ReportViewer1.LocalReport.DisplayName = "";
                }
                else
                {
                    ReportViewer1.Visible = false;
                }
            }
        }
        private void Sub_SoYeuLyLich_QHGD(object sender, SubreportProcessingEventArgs e)
        {
            #region create table SoYeuLyLich_QHGD
            DataTable tblSoYeuLyLich_QHGD = new DataTable();
            tblSoYeuLyLich_QHGD.Columns.Add("RELATION_NAME", typeof(string));
            tblSoYeuLyLich_QHGD.Columns.Add("NAME", typeof(string));
            tblSoYeuLyLich_QHGD.Columns.Add("BIRTH_YEAR", typeof(string));
            tblSoYeuLyLich_QHGD.Columns.Add("NAV_ADDRESS", typeof(string));
            tblSoYeuLyLich_QHGD.Columns.Add("JOB", typeof(string));
            tblSoYeuLyLich_QHGD.Columns.Add("WORK_PLACE", typeof(string));
            tblSoYeuLyLich_QHGD.Columns.Add("ADDRESS", typeof(string));
            #endregion
            #region input data
            if (objSYLL != null)
            {
                List<Family> lstFamily = objSYLL.d.data[2].family;
                foreach (Family item in lstFamily)
                {
                    DataRow row = tblSoYeuLyLich_QHGD.NewRow();
                    row["RELATION_NAME"] = item.RELATION_NAME;
                    row["NAME"] = item.NAME;
                    row["BIRTH_YEAR"] = item.BIRTH_YEAR;
                    row["NAV_ADDRESS"] = item.NAV_ADDRESS;
                    row["JOB"] = item.JOB;
                    row["WORK_PLACE"] = item.WORK_PLACE;
                    row["ADDRESS"] = item.ADDRESS;
                    tblSoYeuLyLich_QHGD.Rows.Add(row);
                }
            }
            #endregion
            rds = new ReportDataSource("DataSet_SoYeuLyLich_QHGD", tblSoYeuLyLich_QHGD);
            e.DataSources.Add(rds);
        }
        private void Sub_SoYeuLyLich_QHGD_TrinhDoDaoTao(object sender, SubreportProcessingEventArgs e)
        {
            #region create table SoYeuLyLich_QHGD_TrinhDoDaoTao
            DataTable tblSoYeuLyLich_QHGD_TrinhDoDaoTao = new DataTable();
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("TENTRUONG", typeof(string));
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("NGANHHOC", typeof(string));
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("TUNGAY", typeof(string));// MM/yyyy
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("DENNGAY", typeof(string));// MM/yyyy
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("HINHTHUCDAOTAO", typeof(string));
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("BANGCAP", typeof(string));
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("TEN_BANGCAP", typeof(string));
            tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Columns.Add("TEN_HINHTHUCDAOTAO", typeof(string));
            #endregion
            #region input data
            if (objSYLL != null)
            {
                List<Training> lstTraining = objSYLL.d.data[1].training;
                foreach (Training item in lstTraining)
                {
                    DataRow row = tblSoYeuLyLich_QHGD_TrinhDoDaoTao.NewRow();
                    row["TENTRUONG"] = item.TENTRUONG;
                    row["NGANHHOC"] = item.NGANHHOC;
                    row["TUNGAY"] = item.TUNGAY;
                    row["DENNGAY"] = item.DENNGAY;
                    row["HINHTHUCDAOTAO"] = item.HINHTHUCDAOTAO;
                    row["BANGCAP"] = item.BANGCAP;
                    row["TEN_BANGCAP"] = item.TEN_BANGCAP;
                    row["TEN_HINHTHUCDAOTAO"] = item.TEN_HINHTHUCDAOTAO;
                    tblSoYeuLyLich_QHGD_TrinhDoDaoTao.Rows.Add(row);
                }
            }
            #endregion
            rds = new ReportDataSource("DataSet_SoYeuLyLich_QHGD_TrinhDoDaoTao", tblSoYeuLyLich_QHGD_TrinhDoDaoTao);
            e.DataSources.Add(rds);
        }
        private void Sub_SoYeuLyLich_QHGD_Vo(object sender, SubreportProcessingEventArgs e)
        {
            #region create table SoYeuLyLich_QHGD_Vo
            DataTable tblSoYeuLyLich_QHGD_Vo = new DataTable();
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("RELATION_NAME", typeof(string));
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("NAME", typeof(string));
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("BIRTH_YEAR", typeof(string));
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("NAV_ADDRESS", typeof(string));
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("JOB", typeof(string));
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("WORK_PLACE", typeof(string));
            tblSoYeuLyLich_QHGD_Vo.Columns.Add("ADDRESS", typeof(string));
            #endregion
            rds = new ReportDataSource("DataSet_SoYeuLyLich_QHGD_Vo", tblSoYeuLyLich_QHGD_Vo);
            e.DataSources.Add(rds);
        }
        private void Sub_SoYeuLyLich_QTCongTac(object sender, SubreportProcessingEventArgs e)
        {
            #region create table SoYeuLyLich_QTCongTac
            DataTable tblSoYeuLyLich_QTCongTac = new DataTable();
            tblSoYeuLyLich_QTCongTac.Columns.Add("THOI_GIAN", typeof(string));
            tblSoYeuLyLich_QTCongTac.Columns.Add("NOTES", typeof(string));
            #endregion
            rds = new ReportDataSource("DataSet_SoYeuLyLich_QTCongTac", tblSoYeuLyLich_QTCongTac);
            e.DataSources.Add(rds);
        }
        private void Sub_SoYeuLyLich_QTLuong(object sender, SubreportProcessingEventArgs e)
        {
            #region create table SoYeuLyLich_QTLuong
            DataTable tblSoYeuLyLich_QTLuong = new DataTable();
            tblSoYeuLyLich_QTLuong.Columns.Add("EMD", typeof(string));
            tblSoYeuLyLich_QTLuong.Columns.Add("EFFECTDATE", typeof(string));
            tblSoYeuLyLich_QTLuong.Columns.Add("CODE", typeof(string));
            tblSoYeuLyLich_QTLuong.Columns.Add("COEFFICIEN", typeof(string));
            #endregion
            if (objSYLL != null)
            {
                List<Working> lstWorking = objSYLL.d.data[3].working;
                foreach (Working item in lstWorking)
                {
                    DataRow row = tblSoYeuLyLich_QTLuong.NewRow();
                    row["EMD"] = item.EMP;
                    row["EFFECTDATE"] = item.EFFECTDATE;
                    row["CODE"] = item.CODE;
                    row["COEFFICIEN"] = item.COEFFICIENT;
                    tblSoYeuLyLich_QTLuong.Rows.Add(row);
                }
            }
            rds = new ReportDataSource("DataSet_SoYeuLyLich_QTLuong", tblSoYeuLyLich_QTLuong);
            e.DataSources.Add(rds);
        }
        private RootObject GetDataSoYeuLyLich(string MaDongBo)
        {
            objSYLL = null;
            #region Đọc từ file JSON
            //using (StreamReader r = new StreamReader(Server.MapPath("~/GSTP/Thongtinchitietcanbo/SoYeuLyLich/data_JSON_Chuan_SYLL.json")))
            //{
            //    string json = r.ReadToEnd();
            //    json = json.Replace("\"{", "{");
            //    json = json.Replace("}]}]}\"}", "}]}]}}");
            //    objSYLL = JsonConvert.DeserializeObject<RootObject>(json);
            //}
            ////objSYLL = JsonConvert.DeserializeObject<RootObject>(dataISON);
            #endregion
            #region Đọc từ server
            string Ma = "WS_2C", inputData = "{\"id\":\"" + MaDongBo + "\"}", url = "";
            GSTP_LINKSVR linkUrl = dt.GSTP_LINKSVR.Where(x => x.MA == Ma).FirstOrDefault();
            if (linkUrl != null)
            {
                url = linkUrl.LINK;
            }
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.ContentLength = inputData.Length;
            using (Stream webStream = request.GetRequestStream())
            using (StreamWriter requestWriter = new StreamWriter(webStream, System.Text.Encoding.ASCII))
            {
                requestWriter.Write(inputData);
            }
            WebResponse webResponse = request.GetResponse();
            using (Stream webStream = webResponse.GetResponseStream())
            {
                if (webStream != null)
                {
                    using (StreamReader responseReader = new StreamReader(webStream))
                    {
                        string response = responseReader.ReadToEnd();
                        response = response.Replace("\"{", "{");
                        response = response.Replace("\\", "");
                        response = response.Replace("}]}]}\"}", "}]}]}}");
                        objSYLL = JsonConvert.DeserializeObject<RootObject>(response);
                    }
                }
            }
            #endregion
            return objSYLL;
        }
    }
}