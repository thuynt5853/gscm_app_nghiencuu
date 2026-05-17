using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.BAOCAOCA.Popup
{
    public partial class ThongTinVAMHCA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        public Decimal VuAnID = 0;
        #region Nhom list
        public class ListStringVuAn_SoThuLy
        {
            public string txtVuAn_SoThuLy { get; set; }
        }
        public class ListStringBanAnDenghi
        {
            public string lttBanAnDenghi { get; set; }
        }
        public class ListStringVuAn_NguoiKhieuNai
        {
            public string lttVuAn_NguoiKhieuNai { get; set; }
        }
        public class ListStringGQDThongTin
        {
            public string lttGQDThongTin { get; set; }
        }
        public class ListStringThuLyXXGDTTT
        {
            public string lttThuLyXXGDTTT { get; set; }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrintContent);

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    if (VuAnID > 0)
                    {
                        //GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        var obj = DataExtensions.GetAllByVuAnId<DASHBOARD_GDT>(VuAnID);
                        LoadThongTinVuAn(obj);
                        //---------------------------
                        try
                        {
                            LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                            LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                        }
                        catch (Exception ex) { }
                        //---------------------
                        try
                        {
                            Load_GQDon(obj);
                        }
                        catch (Exception ex) { }
                        //----------------------
                        try
                        {
                            Load_ThuLyXXGDTTT(obj);
                        }
                        catch (Exception ex) { }

                        if (obj.FirstOrDefault().LOAIAN == "1")
                        {
                            txtQHPL.InnerText = "Tội danh";
                            txtNguyenDon.InnerText = "Bị cáo đầu vụ";
                            txtBiDon.InnerText = "Bị cáo khác";
                        }
                        else
                        {
                            txtQHPL.InnerText = "Quan hệ pháp luật";
                            txtNguyenDon.InnerText = "Nguyên đơn/ Người khởi kiện";
                            txtBiDon.InnerText = "Bị đơn/ Người bị kiện";
                        }
                    }
                }
            }
        }
        //--------------------------------------------------------------------
        void LoadThongTinVuAn(List<DASHBOARD_GDT> obj)
        {
            string temp = "";
            string temp_str = "";
            decimal temp_id = 0;
            List<ListStringVuAn_SoThuLy> ListStringVuAn_SoThuLy = new List<ThongTinVAMHCA.ListStringVuAn_SoThuLy>();
            List<ListStringBanAnDenghi> ListStringBanAnDenghi = new List<ThongTinVAMHCA.ListStringBanAnDenghi>();
            List<ListStringVuAn_NguoiKhieuNai> ListStringVuAn_NguoiKhieuNai = new List<ThongTinVAMHCA.ListStringVuAn_NguoiKhieuNai>();
            
            for (int i = 0; i < obj.Count; i++)
            {
                ListStringVuAn_SoThuLy lstVuAn_SoThuLy = new ListStringVuAn_SoThuLy();
                ListStringBanAnDenghi lstBanAnDenghi = new ListStringBanAnDenghi();
                ListStringVuAn_NguoiKhieuNai lstVuAn_NguoiKhieuNai = new ListStringVuAn_NguoiKhieuNai();
                lttQHPL.Text = obj[i].QUANHEPL;
                //--------------------------
                #region loai an
                temp_str = "";
                temp_id = String.IsNullOrEmpty(obj[i].LOAIAN + "") ? 0 : decimal.Parse(obj[i].LOAIAN);
                if (temp_id > 0)
                {
                    if (temp_id < 10)
                        temp_str = "0" + temp_id + "";
                    else
                        temp_str = temp_id + "";
                    switch (temp_str)
                    {
                        case ENUM_LOAIVUVIEC.AN_HINHSU:
                            lttLoaiAn.Text = "Hình sự";
                            break;
                        case ENUM_LOAIVUVIEC.AN_DANSU:
                            lttLoaiAn.Text = "Dân sự";
                            break;
                        case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                            lttLoaiAn.Text = "Hành chính";
                            break;
                        case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                            lttLoaiAn.Text = "Hôn nhân gia đình";
                            break;
                        case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                            lttLoaiAn.Text = "Kinh doanh, thương mại";
                            break;
                        case ENUM_LOAIVUVIEC.AN_LAODONG:
                            lttLoaiAn.Text = "Lao động";
                            break;
                    }
                }
                #endregion
                //------------------------------
                try
                {
                    txtVuAn_SoThuLy.Text = (String.IsNullOrEmpty(obj[i].SOTHULY + "") ? "" : ("Số <b>" + obj[i].SOTHULY + "</b>"))
                                            + ((String.IsNullOrEmpty(obj[i].NGAYTHULY + "") || (obj[i].NGAYTHULY == DateTime.MinValue)) ? "" : (" ngày <b>" + ((DateTime)obj[i].NGAYTHULY).ToString("dd/MM/yyyy", cul) + "</b>"));
                    lstVuAn_SoThuLy.txtVuAn_SoThuLy = txtVuAn_SoThuLy.Text.Trim();
                }
                catch (Exception ex) { txtVuAn_SoThuLy.Text = ex.ToString(); }
                //------------------------------
                #region BA/QD
                temp = temp_str = "";
                try
                {
                    temp = string.IsNullOrEmpty(obj[i].SOBA) ? "" : $"Số <b>{obj[i].SOBA}</b>";

                    if (!string.IsNullOrEmpty(obj[i].NGAYBA))
                    {
                        DateTime ngayBa;
                        if (DateTime.TryParseExact(obj[i].NGAYBA, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayBa))
                        {
                            temp += $" ngày <b>{ngayBa:dd/MM/yyyy}</b>";
                        }
                    }
                    lttBanAnDenghi.Text = temp.Trim();
                    lstBanAnDenghi.lttBanAnDenghi = lttBanAnDenghi.Text;
                }
                catch (Exception ex) { lttBanAnDenghi.Text = ex.ToString(); }

                DM_TOAAN objTA = null;
                var TOAXX = String.IsNullOrEmpty(obj[i].TOAXX + "") ? 0 : obj[i].TOAXX;
                if (TOAXX > 0)
                {
                    objTA = DataExtensions.FindById<DM_TOAAN>(obj[i].TOAXX.Value);
                    lttToaXuDenghi.Text = objTA.MA_TEN;
                }
                #endregion
                //------------------------
                lttVuAn_NguoiKhieuNai.Text = (string.IsNullOrEmpty(obj[i].NGUOIGUIDON + "")) ? "" :
                    (obj[i].NGUOIGUIDON == "1" ? "Kháng nghị của VKSTC" : obj[i].NGUOIGUIDON);

                lstVuAn_NguoiKhieuNai.lttVuAn_NguoiKhieuNai = lttVuAn_NguoiKhieuNai.Text.Trim();

                ListStringVuAn_SoThuLy.Add(lstVuAn_SoThuLy);
                ListStringBanAnDenghi.Add(lstBanAnDenghi);
                ListStringVuAn_NguoiKhieuNai.Add(lstVuAn_NguoiKhieuNai);
            }
            //-----------------------------------------------------------------
            var GroupVuAn_SoThuLy = ListStringVuAn_SoThuLy.GroupBy(o => o.txtVuAn_SoThuLy).ToArray();
            for (int i = 0; i < GroupVuAn_SoThuLy.Length; i++)
            {
                if (i == 0)
                {
                    txtVuAn_SoThuLy.Text = ListStringVuAn_SoThuLy[i].txtVuAn_SoThuLy;
                }
                else
                {
                    txtVuAn_SoThuLy.Text += "<br/>";
                    txtVuAn_SoThuLy.Text += "<span class='line_space'>";
                    txtVuAn_SoThuLy.Text += ListStringVuAn_SoThuLy[i].txtVuAn_SoThuLy;
                    txtVuAn_SoThuLy.Text += "</span>";
                }
            }
            var GroupBanAnDenghi = ListStringBanAnDenghi.GroupBy(o => o.lttBanAnDenghi).ToArray();
            for (int i = 0; i < GroupBanAnDenghi.Length; i++)
            {
                if (i == 0)
                {
                    lttBanAnDenghi.Text = ListStringBanAnDenghi[i].lttBanAnDenghi;
                }
                else
                {
                    lttBanAnDenghi.Text += "<br/>";
                    lttBanAnDenghi.Text += "<span class='line_space'>";
                    lttBanAnDenghi.Text += ListStringBanAnDenghi[i].lttBanAnDenghi;
                    lttBanAnDenghi.Text += "</span>";
                }
            }
            var GroupVuAn_NguoiKhieuNai = ListStringVuAn_NguoiKhieuNai.GroupBy(o => o.lttVuAn_NguoiKhieuNai).ToArray();
            for (int i = 0; i < GroupVuAn_NguoiKhieuNai.Length; i++)
            {
                if (i == 0)
                {
                    lttVuAn_NguoiKhieuNai.Text = ListStringVuAn_NguoiKhieuNai[i].lttVuAn_NguoiKhieuNai;
                }
                else
                {
                    lttVuAn_NguoiKhieuNai.Text += ", " + ListStringVuAn_NguoiKhieuNai[i].lttVuAn_NguoiKhieuNai;
                }
            }
        }       
        void Load_GQDon(List<DASHBOARD_GDT> objVA)
        {
            string temp = "";
            List<ListStringGQDThongTin> ListStringGQDThongTin = new List<ThongTinVAMHCA.ListStringGQDThongTin>();
            for (int i = 0; i < objVA.Count; i++)
            {
                ListStringGQDThongTin lst = new ThongTinVAMHCA.ListStringGQDThongTin();
                String loai_gqd = Convert.ToString(objVA[i].KQLOAI);
                if (loai_gqd == "0")
                {
                    temp = "Trả lời đơn - ";
                }
                else if (loai_gqd == "1")
                {
                    temp = "CA Kháng nghị - ";
                }
                else if (loai_gqd == "2")
                {
                    temp = "Xếp đơn - ";
                }
                //else if (loai_gqd == "3")
                //{
                //    temp = "Xử lý khác ";
                //}
                //else if (loai_gqd == "4")
                //{
                //    temp = "Kháng nghị VKS";
                //}
                else
                {
                    temp = "Đang giải quyết - ";
                }
                if (!string.IsNullOrEmpty(objVA[i].KQSO))
                {
                    temp += "Số <b>" + objVA[i].KQSO + "</b>";
                }
                if (objVA[i].KQNGAY != null)
                {
                    temp += " ngày <b>" + objVA[i].KQNGAY.Value.ToString("dd/MM/yyyy") + "</b>";
                }
                lttGQDThongTin.Text = temp.Trim();
                lst.lttGQDThongTin = lttGQDThongTin.Text;
                ListStringGQDThongTin.Add(lst);
            }
            var GroupGQDThongTin = ListStringGQDThongTin.GroupBy(o => o.lttGQDThongTin).ToArray();
            //---------------------
            for (int i = 0; i < GroupGQDThongTin.Length; i++)
            {
                if (i == 0)
                {
                    lttGQDThongTin.Text = ListStringGQDThongTin[i].lttGQDThongTin;
                }
                else
                {
                    lttGQDThongTin.Text += "<br/>";
                    lttGQDThongTin.Text += "<span class='line_space'>";
                    lttGQDThongTin.Text += ListStringGQDThongTin[i].lttGQDThongTin;
                    lttGQDThongTin.Text += "</span>";
                }
            }
        }
        void Load_ThuLyXXGDTTT(List<DASHBOARD_GDT> objVA)
        {
            String StrDisplay = "", date_temp = "";
            List<ListStringThuLyXXGDTTT> ListStringThuLyXXGDTTT = new List<ThongTinVAMHCA.ListStringThuLyXXGDTTT>();
            for (int i = 0; i < objVA.Count; i++)
            {
                ListStringThuLyXXGDTTT lst = new ThongTinVAMHCA.ListStringThuLyXXGDTTT();
                String temp_so = (string.IsNullOrEmpty(objVA[i].SOTHULYXX + "") ? "" : "Số <b>" + objVA[i].SOTHULYXX.ToString() + "</b>");

                if (string.IsNullOrEmpty(objVA[i].NGAYTHULYXX + "") || objVA[i].NGAYTHULYXX == DateTime.MinValue)
                    date_temp = "";
                else date_temp = "ngày <b>" + ((DateTime)objVA[i].NGAYTHULYXX).ToString("dd/MM/yyyy", cul) + "</b>";

                StrDisplay = temp_so + (String.IsNullOrEmpty(date_temp + "") ? "" : "   ") + date_temp;

                lttThuLyXXGDTTT.Text = StrDisplay.Trim();
                lst.lttThuLyXXGDTTT = lttThuLyXXGDTTT.Text;
                ListStringThuLyXXGDTTT.Add(lst);
            }
            var GroupThuLyXXGDTTT = ListStringThuLyXXGDTTT.GroupBy(o => o.lttThuLyXXGDTTT).ToArray();
            //-------------------------------------------------------
            for (int i = 0; i < GroupThuLyXXGDTTT.Length; i++)
            {
                if (i == 0)
                {
                    lttThuLyXXGDTTT.Text = ListStringThuLyXXGDTTT[i].lttThuLyXXGDTTT;
                }
                else
                {
                    lttThuLyXXGDTTT.Text += "<br/>";
                    lttThuLyXXGDTTT.Text += "<span class='line_space'>";
                    lttThuLyXXGDTTT.Text += ListStringThuLyXXGDTTT[i].lttThuLyXXGDTTT; ;
                    lttThuLyXXGDTTT.Text += "</span>";
                }
            }
            pnNgayThuLyXXGDT.Visible = !String.IsNullOrEmpty(StrDisplay);
            pnNgayNhanHSTuVKS.Visible = false;
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
    }
}
