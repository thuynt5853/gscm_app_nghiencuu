using BL.GSTP;
using BL.GSTP.Danhmuc;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using BL.THONGKE;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using DAL.GSTP;
using BL.ThongKe;
using System.Reflection;
using Oracle.ManagedDataAccess.Client;

namespace WEB.GSTP.Baocao.ImportBaocao
{
    public partial class Danhsach : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        protected void tonghop_baocao_Unload(object sender, EventArgs e)
        {
            RegisterUpdatePanel((UpdatePanel)sender);
        }
        protected void RegisterUpdatePanel(UpdatePanel panel)
        {
            var sType = typeof(ScriptManager);
            var mInfo = sType.GetMethod("System.Web.UI.IScriptManagerInternal.RegisterUpdatePanel", BindingFlags.NonPublic | BindingFlags.Instance);
            if (mInfo != null)
                mInfo.Invoke(ScriptManager.GetCurrent(Page), new object[] { panel });
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdTongHop);
            //CONVERT SESSION
            ConvertSessions cs = new ConvertSessions();
            if (cs.convertSession2() == false)
            {
                return;
            }
            if (!IsPostBack)
            {
                Load_Data();
                Drop_Levels_init();
                Drop_courts_init();
                Drop_courts_ext_init();
                ddlLoaiAn_init();
                ddlBaoCao_init();
                ddlBaoCao_SelectedIndexChanged(null, null);
            }
        }
        protected void cmdTongHop_Click(object sender, EventArgs e)
        {
            /*
            //TEST PROCEDURE OF DATA TABLE TYPE
            TEST_BL test = new TEST_BL();
            DataTable tbl = test.test1();
            int c = tbl.Rows.Count;
            return;
            */
            if (Cls_Comon.IsValidDate(txtNgay.Text) == false)
            {
                lstMsg.Text = "Chưa nhập ngày mở phiên tòa hoặc không hợp lệ !";
                txtNgay.Focus();
                return;
            }
            if (Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
            {
                lstMsg.Text = "Chưa nhập ngày mở phiên tòa hoặc không hợp lệ !";
                txtNgay.Focus();
                return;
            }

            DateTime TuNgay = DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (TuNgay > DenNgay)
            {
                lstMsg.Text = "Từ ngày không được lớn hơn đến ngày. Hãy xem lại!";
                txtNgay.Focus();
                return;
            }
            try
            {
                GSTPContext gscm = new GSTPContext();
                DateTime TuNgayTongHop = DateTime.Parse(this.txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime DenNgayTongHop = DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                bool result = false;
                int _COURT_ID = 0, _COURT_EXTID = 0, _REPORT_TIME_ID = 0,
                    _ISDONVITRUCTHUOC = 0, _ID_BAOCAO = int.Parse(ddlBaoCao.SelectedValue);
                //string _COURT_LOAIDONVI = "";
                if (Drop_courts.Items.Count > 0)
                    _COURT_ID = int.Parse(Drop_courts.SelectedValue);
                if (Drop_courts_ext.Items.Count > 0)
                    _COURT_EXTID = int.Parse(Drop_courts_ext.SelectedValue);
                if (Drop_courts_ext.Visible)
                {
                    if (Drop_courts_ext.SelectedIndex != 0)
                    {
                        _ISDONVITRUCTHUOC = 1;// Có tổng hợp đơn vị trực thuộc (đơn vị cấp dưới)
                    }
                }
                //DM_TOAAN toaan = gscm.DM_TOAAN.Where(x => x.ID == _COURT_ID).FirstOrDefault();
                //if (toaan != null)
                //    _COURT_LOAIDONVI = toaan.LOAITOA;
                int tuNam = TuNgayTongHop.Year, tuThang = TuNgayTongHop.Month, tuNgay = TuNgayTongHop.Day;


                int denNam = DenNgayTongHop.Year, denThang = DenNgayTongHop.Month, denNgay = DenNgayTongHop.Day;

                for(int i = tuNam; i <= denNam; i++)
                {
                    for (int j = 1; j <= 12; j++)
                    {
                        for (int k = 1; k <= 31; k++)
                        {
                            if (CheckDay(k, j, i))
                            {
                                _REPORT_TIME_ID = int.Parse(i.ToString() + (j<10?'0'+j.ToString():j.ToString()) + (k<10?'0'+k.ToString():k.ToString()));
                                if (int.Parse(TuNgay.ToString("yyyyMMdd")) <= _REPORT_TIME_ID && int.Parse(DenNgay.ToString("yyyyMMdd")) >= _REPORT_TIME_ID)
                                {
                                    M_Scheduler M_Objecs = new M_Scheduler();
                                    result = M_Objecs.ReportInsert_Scheduler(_COURT_ID, _COURT_EXTID, _ISDONVITRUCTHUOC, _REPORT_TIME_ID, _ID_BAOCAO);
                                    if (result)
                                    {
                                        lstMsg.Text = "Tổng hợp thành công.";
                                        txtNgay.Text = "";
                                        Load_Data();
                                    }
                                    else
                                    {
                                        lstMsg.Text = "Gặp lỗi trong quá trình tổng hợp dữ liệu.";
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            catch (Exception ex)
            {
                lstMsg.Text = ex.Message;
            }
        }

        public bool CheckDay(int day, int month, int year)
        {
            string strYear = year.ToString();
            int x = strYear[0] * 10 + strYear[1];
            if (year%4 == 0 || (year %100 ==0 && year % 400 == 0) || x%4==0)
            {
                if(month == 2)
                {
                    if (day < 30)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else if(month == 4 || month == 6 || month == 9 || month == 11)
                {
                    if (day < 31)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return true;
                }
            }
            else
            {
                if (month == 2)
                {
                    if (day < 29)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11)
                {
                    if (day < 31)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return true;
                }
            }
        }

        private void Load_Data()
        {
            DM_LICHSU_THSL_BL TongHopBL = new DM_LICHSU_THSL_BL();
            int CurPage = Convert.ToInt32(hddPageIndex.Value), PageSize = Convert.ToInt32(hddPageSize.Value);
            int _COURT_ID = int.Parse(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            int _REPORT_TIME_ID = 0;
            if (!String.IsNullOrEmpty(txtNgay.Text.Trim()))
            {
                DateTime dt = DateTime.Parse(this.txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                _REPORT_TIME_ID = int.Parse(dt.ToString("yyyyMMdd"));
            }
            DataTable oDT = TongHopBL.DM_LICHSU_THSL_GETALL(_COURT_ID, _REPORT_TIME_ID, CurPage, PageSize);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                div_PhanTrang_T.Visible = div_PhanTrang_D.Visible = dgList.Visible = true;
                int Total = Convert.ToInt32(oDT.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.CurrentPageIndex = 0;
                dgList.PageSize = Convert.ToInt32(hddPageSize.Value);
                dgList.DataSource = oDT;
                dgList.DataBind();
            }
            else
            {
                lbtthongbao.Text = "Không có đơn vị thay đổi số liệu.";
                div_PhanTrang_T.Visible = div_PhanTrang_D.Visible = dgList.Visible = false;
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }
        #endregion

        #region "PHAN LOAI BAO CAO THEO TOA"
        //
        //############ PHAN LOAI TOA AN ##############################################################################################
        //
        // Load Cấp tòa 
        private void Drop_Levels_init()
        {
            string loaitoa = Session["LOAITOA"] + "";
            if (loaitoa == "TOICAO")
            {
                Drop_Levels.Items.Add(new ListItem("Tối cao", "TW"));
            }
            else if (loaitoa == "CAPCAO")
            {
                Drop_Levels.Items.Add(new ListItem("Cấp cao", "CW"));
            }
            else if (loaitoa == "CAPTINH")
            {
                Drop_Levels.Items.Add(new ListItem("Tỉnh/TP", "T"));
            }
            else if (loaitoa == "CAPHUYEN")
            {
                Drop_Levels.Items.Add(new ListItem("Quận/Huyện", "H"));
            }
        }
        // Load Tòa án Login
        private void Drop_courts_init()
        {
            M_Courts M_Objects = new M_Courts();
            List<Courts> items = null;

            Int32 courtId = Int32.Parse(Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString()));
            string courtName = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
            string loaitoa_selected = Drop_Levels.SelectedValue;

            if (loaitoa_selected == "TW")
            {
                //TW
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
                //trường hợp đặc biệt, map lại tòa án tối cao giữa 2 hệ thông
                foreach (Courts item in items)
                {
                    if (item.ID.ToString() == courtId.ToString()) item.COURT_NAME = courtName;
                }
            }
            else if (loaitoa_selected == "CW")
            {
                //CW
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
            }
            else if (loaitoa_selected == "T")
            {
                //T
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
            }
            else if (loaitoa_selected == "H")
            {
                //H
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
            }
            Drop_courts.DataSource = items;
            Drop_courts.DataBind();

            //Xác định Tòa án cho phép chọn
            foreach (ListItem item in Drop_courts.Items)
            {
                //chọn mặc định tòa đăng nhập
                if (item.Value == courtId.ToString()) item.Selected = true;
                //loại bỏ các tòa khác
                if (item.Value != courtId.ToString()) item.Enabled = false;
            }

        }
        // Load Tòa án trực thuộc Tòa án Login
        private void Drop_courts_ext_init()
        {
            string loaitoa_selected = Drop_Levels.SelectedValue;
            Int32 courtId_selected = Int32.Parse(Drop_courts.SelectedValue);

            M_Courts M_Objects = new M_Courts();
            List<Courts> items = null;

            if (loaitoa_selected == "TW")
            {
                items = M_Objects.List_Couts_All_For_Type("CW");
            }
            else if (loaitoa_selected == "CW")
            {
                //items = M_Objects.List_Couts_All_For_Type("CW");
                items = M_Objects.Court_List_Id_Not_All_CW(courtId_selected);
            }
            else if (loaitoa_selected == "T")
            {
                //items = M_Objects.Court_List_Id_Not_All_CW(courtId_selected);
                items = M_Objects.Court_List_Id_Not_All(courtId_selected);
            }

            Drop_courts_ext.DataSource = items;
            Drop_courts_ext.DataBind();
            Drop_courts_ext.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            Drop_courts_ext.SelectedIndex = 0;
        }
        // Load Loại án
        private void ddlLoaiAn_init()
        {
            ddlLoaiAn.Items.Clear();
            string id_courts = Drop_courts.SelectedValue;
            M_Functions M_Objects = new M_Functions();
            List<Functions> List_Functions = M_Objects.Function_List_Courts(id_courts);

            //string loaitoa_selected = Drop_Levels.SelectedValue;
            //List<Functions> List_Functions = M_Objects.Function_List_Courts_type(loaitoa_selected);

            int[] arsv = new int[10] { 18, 26, 32, 37, 42, 47, 53, 57, 61, 65 };
            //SELECT * FROM TC_FUNCTIONS TC WHERE TC.POSTION=1 and TC.ID_PARENT=0 and TC.ID <>1 ORDER BY TC.ID;

            ddlLoaiAn.Items.Clear();
            int vsi = 0;
            foreach (Functions its in List_Functions)
            {//its.ID=57 ap dung cac bien phap xu ly hanh chinh
                if ((its.ID_PARENT == 0) && (its.POSTION == 1) && (its.ID != 1) && (its.ID != 57))
                {
                    for (int i = 0; i <= 9; i++)
                    {
                        if (its.ID == arsv[i])
                        {
                            vsi = Convert.ToInt32(its.ID);
                            break;
                        }
                    }
                    ListItem ites = new ListItem(its.FUNCTION_NAME, vsi.ToString());
                    ddlLoaiAn.Items.Add(ites);
                }
            }
        }
        // Load Báo cáo
        private void ddlBaoCao_init()
        {
            ddlBaoCao.Items.Clear();
            string id_courts = Drop_courts.SelectedValue,
                //is_DonViTrucThuoc = "0", 
                LoaiToa = Drop_Levels.SelectedValue + ",";
            //if (Drop_courts_ext.Visible) is_DonViTrucThuoc = "1";
            decimal LoaiAnID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);

            M_Functions M_Objects = new M_Functions();
            List<Functions> List_Functions = M_Objects.Function_List_Courts(id_courts);

            foreach (Functions its in List_Functions)
            {//its.ID=57 ap dung cac bien phap xu ly hanh chinh
                if ((its.ID_PARENT == LoaiAnID) && (its.POSTION == 1) && (its.ID != 1) && (its.ID != 57))
                {
                    //if (is_DonViTrucThuoc == "1" && its.DESCRIPTION.Contains(LoaiToa))
                    //{
                    //    ListItem ites = new ListItem(its.FUNCTION_NAME, its.ID.ToString());
                    //    ddlBaoCao.Items.Add(ites);
                    //}
                    //if (is_DonViTrucThuoc == "0")
                    //{
                    //    ListItem ites = new ListItem(its.FUNCTION_NAME, its.ID.ToString());
                    //    ddlBaoCao.Items.Add(ites);
                    //}
                    ListItem ites = new ListItem(its.FUNCTION_NAME, its.ID.ToString());
                    ddlBaoCao.Items.Add(ites);
                }
            }
        }
        protected void Drop_Levels_SelectedIndexChanged(object sender, EventArgs e)
        {
            //lbToaTrucThuoc.Visible = false;
            //Drop_courts_ext.Visible = false;
            //string CapToaLogin = Session["LOAITOA"] + "",CapToaDrop = Drop_Levels.SelectedValue + "",CapToaBaoCao = "";
            //decimal BaoCaoID = Convert.ToDecimal(ddlBaoCao.SelectedValue);
            //M_Functions M_Objects = new M_Functions();
            //List<Functions> List_Functions = M_Objects.Function_List_ByID(BaoCaoID);
            //if (List_Functions.Count > 0)
            //{
            //    CapToaBaoCao = List_Functions[0].DESCRIPTION + "";
            //}
            //// xét ẩn hiện đơn vị trực thuộc
            //if (CapToaLogin == "TOICAO")
            //{

            //}
            //else if (CapToaLogin == "CAPCAO")
            //{
            //    if (CapToaDrop.Contains("T,") && CapToaBaoCao.Contains("T,"))
            //    {
            //        lbToaTrucThuoc.Visible = true;
            //        Drop_courts_ext.Visible = true;
            //    }
            //}
            //else if (CapToaLogin == "CAPTINH")
            //{

            //}
            //else if (CapToaLogin == "CAPHUYEN")
            //{

            //}
            //if (CapToa == "T" && CapToaBaoCao.Contains("T,"))
            //{
            //    lbToaTrucThuoc.Visible = true;
            //    Drop_courts_ext.Visible = true;
            //}
            //else
            //{
            //    lbToaTrucThuoc.Visible = false;
            //    Drop_courts_ext.Visible = false;
            //}
            //ddlBaoCao_init();
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlBaoCao_init();
            ddlBaoCao_SelectedIndexChanged(null, null);
        }
        #endregion
        protected void ddlBaoCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbToaTrucThuoc.Visible = true;
            Drop_courts_ext.Visible = true;
            string CapToaLogin = Session["LOAITOA"] + "", CapToaBaoCao = "";
            decimal BaoCaoID = Convert.ToDecimal(ddlBaoCao.SelectedValue);
            M_Functions M_Objects = new M_Functions();
            List<Functions> List_Functions = M_Objects.Function_List_ByID(BaoCaoID);
            if (List_Functions.Count > 0)
            {
                CapToaBaoCao = List_Functions[0].DESCRIPTION + "";
            }
            // xét ẩn hiện đơn vị trực thuộc
            if (CapToaLogin == "CAPTINH" && CapToaBaoCao.Contains("H,"))
            {
                lbToaTrucThuoc.Visible = false;
                Drop_courts_ext.Visible = false;
            }
            else if (CapToaLogin == "CAPHUYEN")
            {
                lbToaTrucThuoc.Visible = false;
                Drop_courts_ext.Visible = false;
            }
        }
        protected void cmdCheckChange_Click(object sender, EventArgs e)
        {
            DateTime NgayCheck = DateTime.Now;
            if (txtNgay.Text + "" != "")
            {
                if (Cls_Comon.IsValidDate(txtNgay.Text) == false)
                {
                    lstMsg.Text = "Chưa nhập ngày tổng hợp số liệu hoặc không hợp lệ. Hãy kiểm tra lại!";
                    txtNgay.Focus();
                    return;
                }
                NgayCheck = DateTime.Parse(txtNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            }

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_DATE",NgayCheck)
            };
            Cls_Comon.ExcuteProc("SCAN_CHANGE_QLA_WITH_PARAMETER", prm);
            Load_Data();
            lstMsg.Text = "Đã kiểm tra xong.";
        }
    }
}