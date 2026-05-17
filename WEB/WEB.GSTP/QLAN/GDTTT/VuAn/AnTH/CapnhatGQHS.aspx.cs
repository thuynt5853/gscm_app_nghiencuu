using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Globalization;

using Module.Common;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using BL.GSTP.BANGSETGET;
using Oracle.ManagedDataAccess.Client;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.AnTH
{
    public partial class CapnhatGQHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    if (Request["ID"] != null)
                    {
                        hddVuAnID.Value = Request["ID"] + "";
                        LoadThongtinQGTH();
                    }
                }
            }
            else
                Response.Redirect("/Login.aspx");
            ////////////////
        }
      
        void LoadDrop()
        {
         
            LoadAll_TTV_ChuyenLUUHS();
        }
       
        void LoadThongtinQGTH()
        {
            Decimal hs_ID = Convert.ToDecimal(Request["ID"] + "");
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            DataTable tbl = null;
            tbl = oBL.HOSO_TUHINH_SEARCH(Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", hs_ID, 0,
                0, null, null, 0, null, null, null, 1, 20);
            decimal vuanid = Convert.ToDecimal(tbl.Rows[0]["VUAN_ID"]);
            LoadThongTinVuAn(vuanid);

            decimal tt_ctn;
            try
            {
                tt_ctn  = Convert.ToDecimal(tbl.Rows[0]["CAPTRINH"]);
            }
            catch
            {
                tt_ctn = 0;
            }
            if (tt_ctn == 18)
            {
                txtSoTT.Text = Convert.ToString(tbl.Rows[0]["SOTT"]);
                txtNgayTT.Text = Convert.ToString(tbl.Rows[0]["NGAYTT"]);
                txtNoidungTT.Text = Convert.ToString(tbl.Rows[0]["LOAIYK"]);
            }

            Enable_KLCA();
            decimal KLCA;
            try
            {
                KLCA = Convert.ToDecimal(tbl.Rows[0]["KETLUAN_CA"]);
            }
            catch
            {
                KLCA = 0;
            }
            


            if (KLCA > 0)
            {
                ddlKETLUAN_CA.SelectedValue = Convert.ToString(tbl.Rows[0]["KETLUAN_CA"]);
                txtSOQD_CA.Text =  Convert.ToString (tbl.Rows[0]["SOQD_CA"]);
                txtNgayQD_CA.Text =  (String.IsNullOrEmpty(tbl.Rows[0]["NGAYQD_CA"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYQD_CA"]).ToString("dd/MM/yyyy", cul));
                txtNOIDUNG_QD_CA.Text = Convert.ToString(tbl.Rows[0]["NOIDUNG_QD_CA"]);
               
                txtNGAYPHCV_VKS.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYPHCV_VKS"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYPHCV_VKS"]).ToString("dd/MM/yyyy", cul));
                txtGHICHUCV_GUI.Text = Convert.ToString(tbl.Rows[0]["GHICHUCV_GUI"]);
                
                Disable_KLCA();
                cmdUpdateCA.Text = "Sửa";
                cmdDelete_CA.Text = "Xóa";
            }
        
            decimal KLVKS;
            try
            {
                KLVKS = Convert.ToDecimal(tbl.Rows[0]["KETLUAN_VKS"]);
            }
            catch
            {
                KLVKS = 0;
            }

            if (KLVKS >0)
            {
                ddlKETLUAN_VKS.SelectedValue = Convert.ToString(tbl.Rows[0]["KETLUAN_VKS"]);
                txtSOQD_VKS.Text = Convert.ToString(tbl.Rows[0]["SOQD_VKS"]);
                txtNGAYQD_VKS.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYQD_VKS"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYQD_VKS"]).ToString("dd/MM/yyyy", cul));
                txtSoTT_VKS.Text = Convert.ToString(tbl.Rows[0]["SoTT_VKS"]);
                txtNGAYTT_VKS.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYTT_VKS"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYTT_VKS"]).ToString("dd/MM/yyyy", cul));
                ddlNoidungTT_VKS.SelectedValue = Convert.ToString(tbl.Rows[0]["NOIDUNGTT_VKS"]);
                txtGHICHU_VKS_TRA.Text = Convert.ToString(tbl.Rows[0]["GHICHU_VKS_TRA"]);
                Disable_KLVKS();
                cmdUpdateVKS.Text = "Sửa";
                cmdXoa_VKS.Text = "Xóa";
            }

            decimal LOAIQD;
            try
            {
                LOAIQD = Convert.ToDecimal(tbl.Rows[0]["CTN_LOAIQD"]);
            }
            catch
            {
                LOAIQD = 0;
            }

            if (LOAIQD >0)
            { 
                txtCTN_SOQĐ.Text = Convert.ToString(tbl.Rows[0]["CTN_SOQĐ"]);
                txtCTN_NGAYQD.Text = (String.IsNullOrEmpty(tbl.Rows[0]["CTN_NGAYQD"] + "") ? "" : ((DateTime)tbl.Rows[0]["CTN_NGAYQD"]).ToString("dd/MM/yyyy", cul));
                txtCTN_NGAYTRA.Text = (String.IsNullOrEmpty(tbl.Rows[0]["CTN_NGAYTRA"] + "") ? "" : ((DateTime)tbl.Rows[0]["CTN_NGAYTRA"]).ToString("dd/MM/yyyy", cul));
                ddlCTN_LOAIQD.SelectedValue = Convert.ToString(tbl.Rows[0]["CTN_LOAIQD"]);
                txtCTN_GHICHU.Text = Convert.ToString(tbl.Rows[0]["CTN_GHICHU"]);
                Disable_CTN();
                cmdUpdateCTN.Text = "Sửa";
                cmdXoa_CTN.Text = "Xóa";
            }

            string CVXM = Convert.ToString(tbl.Rows[0]["SOCVXM"]);
            if (CVXM != "")
            {
                txtSOCVXM.Text = Convert.ToString(tbl.Rows[0]["SOCVXM"]);
                txtNGAYCVXM.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYCVXM"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYCVXM"]).ToString("dd/MM/yyyy", cul));
                txtNoidungXM.Text = Convert.ToString(tbl.Rows[0]["NOIDUNGXM"]);
                Disable_CVXM();
                cmdUpateCVXM.Text = "Sửa";
                cmdDeleteCVXM.Text = "Xóa";
            }

            decimal lOAIKQCVXM;
            try
            {
                lOAIKQCVXM = Convert.ToDecimal(tbl.Rows[0]["LOAIKETQUAXM"]);
            }
            catch
            {
                lOAIKQCVXM = 0;
            }
        
            if (lOAIKQCVXM > 0 )
            {
                ddlLoaiKQXM.SelectedValue = Convert.ToString(tbl.Rows[0]["LOAIKETQUAXM"]);
                txtNgayKQXM.Text = (String.IsNullOrEmpty(tbl.Rows[0]["NGAYKQXM"] + "") ? "" : ((DateTime)tbl.Rows[0]["NGAYKQXM"]).ToString("dd/MM/yyyy", cul));
                txtKetquaXM.Text = Convert.ToString(tbl.Rows[0]["NOIDUNG_KQXM"]);
                Disable_KQXM();
                cmdUpdate_KQXM.Text = "Sửa";
                cmdDelete_KQXM.Text = "Xóa";
            }

            string CVTHA = Convert.ToString(tbl.Rows[0]["THA_SOCV"]);
           

            string KQTHA = Convert.ToString(tbl.Rows[0]["THA_KETQUA"]);
            if (KQTHA != "")
            {
                ddlTHA_KETQUA.SelectedValue = Convert.ToString(tbl.Rows[0]["THA_KETQUA"]);
                txtTHA_NGAY.Text = (String.IsNullOrEmpty(tbl.Rows[0]["THA_NGAY"] + "") ? "" : ((DateTime)tbl.Rows[0]["THA_NGAY"]).ToString("dd/MM/yyyy", cul));
                txtTHA_DIADIEM.Text = Convert.ToString(tbl.Rows[0]["THA_DIADIEM"]);
                txtTHA_GHICHU.Text = Convert.ToString(tbl.Rows[0]["THA_GHICHU"]);

                Disable_KQTHA();
                cmdUpdate_KQTHA.Text = "Sửa";
                cmdDelete_kqtha.Text = "Xóa";
            }
            decimal LUUHS_NGUOICHUYEN;
            try
            {
                LUUHS_NGUOICHUYEN = Convert.ToDecimal(tbl.Rows[0]["LUUHS_NGUOICHUYEN_ID"]);
            }
            catch
            {
                LUUHS_NGUOICHUYEN = 0;
            }

            if (LUUHS_NGUOICHUYEN > 0)
            {
                txtLUUHS_NGAYCHUYEN.Text = (String.IsNullOrEmpty(tbl.Rows[0]["LUUHS_NGAYCHUYEN"] + "") ? "" : ((DateTime)tbl.Rows[0]["LUUHS_NGAYCHUYEN"]).ToString("dd/MM/yyyy", cul));
                ddlLUUHS_NGUOICHUYEN_ID.SelectedValue = Convert.ToString(tbl.Rows[0]["LUUHS_NGUOICHUYEN_ID"]);
                
                txtLUUHS_NGUOINHAN.Text = Convert.ToString(tbl.Rows[0]["LUUHS_NGUOINHAN"]);
                txtLUUHS_DONVINHAN.Text = Convert.ToString(tbl.Rows[0]["LUUHS_DONVINHAN"]);
                ddlLUUHS_TINHTRANGHS.SelectedValue = Convert.ToString(tbl.Rows[0]["LUUHS_TINHTRANGHS"]);
              
                txtLUUHS_GHICHU.Text = Convert.ToString(tbl.Rows[0]["LUUHS_GHICHU"]);


                Disable_LUUHS();
                cmdUpdateLUUHS.Text = "Sửa";
                cmdDELETE_LUUHS.Text = "Xóa";
            }

        }


        void LoadThongTinVuAn(decimal vuanid)
        {
  
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    lttVuAn.Text = oT.TENVUAN;
                else
                {
                    lttVuAn.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        lttVuAn.Text = lttVuAn.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                hddLoaiAn.Value = oT.LOAIAN + "";
                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

                //----------------------------------
                //LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                
                //-----------------------------
                try
                {
                    Load_TTV_LanhDao(oT);
                }
                catch (Exception ex) { }
            }
        }

        void Load_TTV_LanhDao(GDTTT_VUAN obj)
        {
            String temp_str = "";
            decimal temp_id = 0;
            #region ---------thong tin TTV/LD-----------------
            string temp_ttv = "";
            #region Thông tin TTV/lanh dao
            DM_CANBO objCB = null;
            //----------------------------
            int soluongcot = 6;
            string str_ttv = "", str_ld = "", str_tp = "";

            temp_id = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                temp_str = objCB.HOTEN;
                str_ttv = "<td>Thẩm tra viên</td>";
                str_ttv += "<td><b>" + temp_str + "</b></td>";
                soluongcot = soluongcot - 2;
            }
            //-----------------
            temp_id = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                temp_str = objCB.HOTEN;
                str_ld = "<td>Lãnh đạo vụ</td>";
                str_ld += "<td><b>" + temp_str + "</b></td>";
                soluongcot = soluongcot - 2;
            }
            //-------------------------------
            temp_id = (string.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : (decimal)obj.THAMPHANID;
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                temp_str = objCB.HOTEN;
                str_tp = "<td>Thẩm phán</td>";
                str_tp += "<td><b>" + temp_str + "</b></td>";
                soluongcot = soluongcot - 2;
            }

            //-----------------------------------------------------
            temp_ttv = "<tr>";
            temp_ttv += str_ttv + str_ld + str_tp;
            if (soluongcot > 0)
                temp_ttv += "<td colspan='" + soluongcot + "'></td>";
            temp_ttv += "</tr>";
            #endregion
            lttOther.Text = temp_ttv;
            #endregion
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

        //------------------------------
              
      
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/GDTTT/VuAn/AnTH/DanhsachAnTh.aspx");
        }

        
        protected void txtCTN_NGAYTRA_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtCTN_NGAYQD_TextChanged(object sender, EventArgs e)
        {

        }
        //protected void txtCTN_NGAYNHAN_TextChanged(object sender, EventArgs e)
        //{

        //}
        //protected void txtCTN_NGAYCHUYEN_TextChanged(object sender, EventArgs e)
        //{

        //}
        protected void txtNgayQD_CA_TextChanged(object sender, EventArgs e)
        {

        }

        //protected void txtNGAYCVGUI_VKS_TextChanged(object sender, EventArgs e)
        //{
           

        //}
        protected void txtNGAYPHCV_VKS_TextChanged(object sender, EventArgs e)
        {
            

        }

        //protected void txtNGAYNHAN_VKS_TextChanged(object sender, EventArgs e)
        //{
           

        //}

        protected void txtNGAYQD_VKS_TextChanged(object sender, EventArgs e)
        {
           
        }
        protected void txtNGAYTT_VKS_TextChanged(object sender, EventArgs e)
        {

        }
        

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            
        }
        protected void txtNGAYCVXM_TextChanged(object sender, EventArgs e)
        {

        }
       
        protected void txtNgayKQXM_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtTHA_NGAYCV_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtTHA_NGAYPHCV_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtTHA_NGAY_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtLUUHS_NGAYCHUYEN_TextChanged(object sender, EventArgs e)
        {

        }

        protected void txtLUUHS_NGAYNHAN_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtLUUHS_NGAYTRINH_CA_TextChanged(object sender, EventArgs e)
        {

        }

        public bool GIAIQUYET_Insert_Update(GDTTT_GIAIQUYET_TUHINH obj)
        {

            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TUHINH.GDTTTT_GIAIQUYET_TUHINH_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_loailuu"].Value = obj.LOAI_UP;
            comm.Parameters["v_KETLUAN_CA"].Value = obj.KELUAN_CA;
            comm.Parameters["v_SOQD_CA"].Value = obj.SOQD_CA;
            comm.Parameters["v_NGAYQD_CA"].Value = obj.NGAYQD_CA;

            comm.Parameters["v_NOIDUNG_QD_CA"].Value = obj.NOIDUNGQD_CA;
            comm.Parameters["v_SOCVGUI_VKS"].Value = obj.SOCVGUI_VKS;
            comm.Parameters["v_NGAYCVGUI_VKS"].Value = obj.NGAYCVGUI_VKS;
            comm.Parameters["v_NGAYPHCV_VKS"].Value = obj.NGAYCV_PH_VKS;
            comm.Parameters["v_GHICHUCV_GUI"].Value = obj.GHICHUCV_GUIVKS;
            comm.Parameters["v_NGAYNHAN_VKS"].Value = obj.NGAYNHANCV_VKS;


            comm.Parameters["v_SOQD_VKS"].Value = obj.SOQD_VKS;
            comm.Parameters["v_NGAYQD_VKS"].Value = obj.NGAYQD_VK;
            comm.Parameters["v_KETLUAN_VKS"].Value = obj.KETLUAN_VKS;
            comm.Parameters["v_NGAYTT_VKS"].Value = obj.NGAYTT_VKS;
            comm.Parameters["v_NOIDUNGTT_VKS"].Value = obj.NOIDUNGTRINH_VKS;
            comm.Parameters["v_GHICHU_VKS_TRA"].Value = obj.GHICHU_VKS_TRA;

            comm.Parameters["v_CTN_NGUOICHUYEN_ID"].Value = obj.CTN_NGUOCHUYEN;
            comm.Parameters["v_CTN_NGAYCHUYEN"].Value = obj.CTN_NGAYCHUYEN;
            comm.Parameters["v_CTN_NGUOINHAN"].Value = obj.LUUHS_NGUOINHAN;
            comm.Parameters["v_CTN_NGAYNHAN"].Value = obj.CTN_NGAYNHAN;
            comm.Parameters["v_CTN_SOQĐ"].Value = obj.CTN_SOQD;
            comm.Parameters["v_CTN_NGAYQD"].Value = obj.CTN_NGAYQD;
            comm.Parameters["v_CTN_LOAIQD"].Value = obj.CTN_LOAIQD;
            comm.Parameters["v_CTN_NGAYTRA"].Value = obj.CTN_NGAYTRA;
            comm.Parameters["v_CTN_GHICHU"].Value = obj.CTN_GHICHU;

            //--Công Văn xác minh
            comm.Parameters["v_SOCVXM"].Value = obj.SOCVXM;
            comm.Parameters["v_NGAYCVXM"].Value = obj.NGAYCVXM;
            comm.Parameters["v_NOIDUNGXM"].Value = obj.NOIDUNGXM;


            //-- Kết quả xác minh
            comm.Parameters["v_LOAIKETQUAXM"].Value = obj.LOAIKETQUAXM;
            comm.Parameters["v_NGAYKQXM"].Value = obj.NGAYKQXM;
            comm.Parameters["v_NOIDUNG_KQXM"].Value = obj.NOIDUNG_KQXM;


            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        

        //void LoadAll_TTV()
        //{
        //    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
        //    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
        //    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
        //    Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //    int count = 0;
        //    //-----------------
        //    Decimal ChucDanh_TPTATC = 0;
        //    try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
        //    Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
        //    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
        //    DataTable tblTheoPB = new DataTable();
        //    if (oCB.CHUCDANHID == ChucDanh_TPTATC)
        //    {
        //        tblTheoPB = oGDTBL.GDTTT_Getall_TTV_TheoTP(LoginDonViID, oCB.ID);
        //    }
        //    else
        //    {
        //        tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
        //    }
        //    if (tblTheoPB != null && tblTheoPB.Rows.Count > 0)
        //    {
        //        count = tblTheoPB.Rows.Count;
        //        ddlThamtravien_nhanhs.DataSource = tblTheoPB;
        //        ddlThamtravien_nhanhs.DataTextField = "HOTEN";
        //        ddlThamtravien_nhanhs.DataValueField = "ID";
        //        ddlThamtravien_nhanhs.DataBind();
        //    }
        //    ddlThamtravien_nhanhs.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        //    ddlThamtravien_nhanhs.Items.Insert(count + 1, new ListItem("--- Khác ---", "-1"));
        //}

        //void LoadAll_TTV_ChuyenHS()
        //{
        //    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
        //    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
        //    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
        //    Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //    int count = 0;
        //    //-----------------
        //    Decimal ChucDanh_TPTATC = 0;
        //    try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
        //    Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
        //    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
        //    DataTable tblTheoPB = new DataTable();
        //    if (oCB.CHUCDANHID == ChucDanh_TPTATC)
        //    {
        //        tblTheoPB = oGDTBL.GDTTT_Getall_TTV_TheoTP(LoginDonViID, oCB.ID);
        //    }
        //    else
        //    {
        //        tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
        //    }
        //    if (tblTheoPB != null && tblTheoPB.Rows.Count > 0)
        //    {
        //        count = tblTheoPB.Rows.Count;
        //        ddlCTN_NGUOICHUYEN_ID.DataSource = tblTheoPB;
        //        ddlCTN_NGUOICHUYEN_ID.DataTextField = "HOTEN";
        //        ddlCTN_NGUOICHUYEN_ID.DataValueField = "ID";
        //        ddlCTN_NGUOICHUYEN_ID.DataBind();
        //    }
        //    ddlCTN_NGUOICHUYEN_ID.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        //    ddlCTN_NGUOICHUYEN_ID.Items.Insert(count + 1, new ListItem("--- Khác ---", "-1"));
        //}

        void LoadAll_TTV_ChuyenLUUHS()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int count = 0;
            //-----------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            DataTable tblTheoPB = new DataTable();
            if (oCB.CHUCDANHID == ChucDanh_TPTATC)
            {
                tblTheoPB = oGDTBL.GDTTT_Getall_TTV_TheoTP(LoginDonViID, oCB.ID);
            }
            else
            {
                tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            }
            if (tblTheoPB != null && tblTheoPB.Rows.Count > 0)
            {
                count = tblTheoPB.Rows.Count;
                ddlLUUHS_NGUOICHUYEN_ID.DataSource = tblTheoPB;
                ddlLUUHS_NGUOICHUYEN_ID.DataTextField = "HOTEN";
                ddlLUUHS_NGUOICHUYEN_ID.DataValueField = "ID";
                ddlLUUHS_NGUOICHUYEN_ID.DataBind();
            }
            ddlLUUHS_NGUOICHUYEN_ID.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlLUUHS_NGUOICHUYEN_ID.Items.Insert(count + 1, new ListItem("--- Khác ---", "-1"));
        }
        protected void cmdUpdateCA_Click(object sender, EventArgs e)
        {

            if (cmdUpdateCA.Text == "Sửa")
            {
                Enable_KLCA();
                cmdUpdateCA.Text = "Lưu";
                cmdDelete_CA.Text = "Hủy";

            }
            else if (cmdUpdateCA.Text == "Lưu")
            {
                
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();
            
                obj.LOAI_UP = 1;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                obj.KELUAN_CA =Convert.ToDecimal( ddlKETLUAN_CA.SelectedValue);
                obj.SOQD_CA = txtSOQD_CA.Text.Trim();
                obj.NGAYQD_CA = DateTime.Parse(this.txtNgayQD_CA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NOIDUNGQD_CA = txtNOIDUNG_QD_CA.Text.Trim();
               
                obj.NGAYCV_PH_VKS = DateTime.Parse(this.txtNGAYPHCV_VKS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.GHICHUCV_GUIVKS = txtGHICHUCV_GUI.Text.Trim();


                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_KLCA();
                cmdUpdateCA.Text = "Sửa";
                cmdDelete_CA.Text = "Xóa";

            }
                
        }

        protected void cmdDelete_CA_Click(object sender, EventArgs e)
        {
            if (cmdDelete_CA.Text == "Hủy")
            {
                Disable_KLCA();
                cmdUpdateCA.Text = "Sửa";
                cmdDelete_CA.Text = "Xóa";
                
            }
            else if (cmdDelete_CA.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 1;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                ddlKETLUAN_CA.SelectedValue = "0";
                txtSOQD_CA.Text = "";
                txtNgayQD_CA.Text = "";
                txtNOIDUNG_QD_CA.Text = "";
               
                txtNGAYPHCV_VKS.Text = "";
               
                txtGHICHUCV_GUI.Text = "";


                Enable_KLCA();
                cmdUpdateCA.Text = "Lưu";
                cmdDelete_CA.Text = "Hủy";
            }
            

        }
        protected void cmdUpdateVKS_Click(object sender, EventArgs e)
        {
            if (cmdUpdateVKS.Text == "Sửa")
            {
                Enable_KLVKS();
                cmdUpdateVKS.Text = "Lưu";
                cmdXoa_VKS.Text = "Hủy";

            }
            else if (cmdUpdateVKS.Text == "Lưu")
            {
              
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 2;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                
                obj.KETLUAN_VKS = Convert.ToDecimal(ddlKETLUAN_VKS.SelectedValue); 
                obj.SOQD_VKS = txtSOQD_VKS.Text.Trim();
                obj.NGAYQD_VK = DateTime.Parse(this.txtNGAYQD_VKS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                obj.SOTT_VKS = txtSoTT_VKS.Text.Trim();
                obj.NGAYTT_VKS = DateTime.Parse(this.txtNGAYTT_VKS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NOIDUNGTRINH_VKS = Convert.ToDecimal(ddlNoidungTT_VKS.SelectedValue);

                obj.GHICHU_VKS_TRA = txtGHICHU_VKS_TRA.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_KLVKS();
                cmdUpdateVKS.Text = "Sửa";
                cmdXoa_VKS.Text = "Xóa";

            }
        }
        protected void cmdXoa_VKS_Click(object sender, EventArgs e)
        {
            if (cmdXoa_VKS.Text == "Hủy")
            {
                Disable_KLVKS();
                cmdUpdateVKS.Text = "Sửa";
                cmdXoa_VKS.Text = "Xóa";

            }
            else if (cmdXoa_VKS.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 2;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                ddlKETLUAN_VKS.SelectedValue = "0";
                txtSOQD_VKS.Text = "";
                txtNGAYQD_VKS.Text = "";
                txtNGAYTT_VKS.Text = "";
                ddlNoidungTT_VKS.SelectedValue = "0";
                txtGHICHU_VKS_TRA.Text = "";
             

                Enable_KLVKS();
                cmdUpdateCTN.Text = "Lưu";
                cmdXoa_VKS.Text = "Hủy";
            }

        }
        //------------------------------


        protected void cmdUpdateCTN_Click(object sender, EventArgs e)
        {
            if (cmdUpdateCTN.Text == "Sửa")
            {
                Enable_CTN();
                cmdUpdateCTN.Text = "Lưu";
                cmdXoa_CTN.Text = "Hủy";

            }
            else if (cmdUpdateCTN.Text == "Lưu")
            {

                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 3;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");

                obj.CTN_LOAIQD = Convert.ToDecimal(ddlCTN_LOAIQD.SelectedValue);
                obj.CTN_SOQD = txtCTN_SOQĐ.Text.Trim();
                obj.CTN_NGAYQD = DateTime.Parse(this.txtCTN_NGAYQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.CTN_NGAYTRA = DateTime.Parse(this.txtCTN_NGAYTRA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.CTN_GHICHU = txtCTN_GHICHU.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_CTN();
                cmdUpdateCTN.Text = "Sửa";
                cmdXoa_CTN.Text = "Xóa";
            }
        }
        protected void cmdXoa_CTN_Click(object sender, EventArgs e)
        {
            if (cmdXoa_CTN.Text == "Hủy")
            {
                Disable_CTN();
                cmdUpdateCTN.Text = "Sửa";
                cmdXoa_CTN.Text = "Xóa";

            }
            else if (cmdXoa_CTN.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 3;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                ddlCTN_LOAIQD.SelectedValue = "0";
                txtCTN_SOQĐ.Text = "";
                txtCTN_NGAYQD.Text = "";
                txtCTN_NGAYTRA.Text = "";
                txtCTN_GHICHU.Text = "";

                Enable_CTN();
                cmdUpdateCTN.Text = "Lưu";
                cmdXoa_CTN.Text = "Hủy";
            }

        }

        protected void cmdUpateCVXM_Click(object sender, EventArgs e)
        {
            if (cmdUpateCVXM.Text == "Sửa")
            {
                Enable_CVXM();
                cmdUpateCVXM.Text = "Lưu";
                cmdDeleteCVXM.Text = "Hủy";

            }
            else if (cmdUpateCVXM.Text == "Lưu")
            {

                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 4;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");

                obj.SOCVXM = txtSOCVXM.Text.Trim();
                obj.NGAYCVXM = DateTime.Parse(this.txtNGAYCVXM.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NOIDUNGXM = txtNoidungXM.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_CVXM();
                cmdUpateCVXM.Text = "Sửa";
                cmdDeleteCVXM.Text = "Xóa";
            }
        }
        protected void cmdDeleteCVXM_Click(object sender, EventArgs e)
        {
            if (cmdDeleteCVXM.Text == "Hủy")
            {
                Disable_CVXM();
                cmdUpateCVXM.Text = "Sửa";
                cmdDeleteCVXM.Text = "Xóa";

            }
            else if (cmdDeleteCVXM.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 4;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                txtSOCVXM.Text = "";
                txtNGAYCVXM.Text = "";
                txtNoidungXM.Text = "";

                Enable_CVXM();
                cmdUpateCVXM.Text = "Lưu";
                cmdDeleteCVXM.Text = "Hủy";
            }

        }
        protected void cmdUpdate_KQXM_Click(object sender, EventArgs e)
        {
            if (cmdUpdate_KQXM.Text == "Sửa")
            {
                Enable_KQXM();
                cmdUpdate_KQXM.Text = "Lưu";
                cmdDelete_KQXM.Text = "Hủy";

            }
            else if (cmdUpdate_KQXM.Text == "Lưu")
            {

                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 5;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");

                obj.LOAIKETQUAXM =Convert.ToDecimal( ddlLoaiKQXM.SelectedValue);
                obj.NGAYKQXM = DateTime.Parse(this.txtNgayKQXM.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NOIDUNG_KQXM = txtKetquaXM.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_KQXM();
                cmdUpdate_KQXM.Text = "Sửa";
                cmdDelete_KQXM.Text = "Xóa";
            }
        }
        protected void cmdDeleteKQXM_Click(object sender, EventArgs e)
        {
            if (cmdDelete_KQXM.Text == "Hủy")
            {

                Disable_KQXM();
                cmdUpdate_KQXM.Text = "Sửa";
                cmdDelete_KQXM.Text = "Xóa";
            }
            else if (cmdDelete_KQXM.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 5;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                txtKetquaXM.Text = "";
                txtNgayKQXM.Text = "";
                ddlLoaiKQXM.SelectedValue = "0";

                Enable_KQXM();
                cmdUpdate_KQXM.Text = "Lưu";
                cmdDelete_KQXM.Text = "Hủy";
            }

        }
        

        protected void cmdUpdate_KQTHA_Click(object sender, EventArgs e)
        {
            if (cmdUpdate_KQTHA.Text == "Sửa")
            {
                Enable_KQTHA();
                cmdUpdate_KQTHA.Text = "Lưu";
                cmdDelete_kqtha.Text = "Hủy";
            }
            else if (cmdUpdate_KQTHA.Text == "Lưu")
            {

                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 8;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");

                obj.THA_KETQUA = ddlTHA_KETQUA.SelectedValue;
                obj.THA_NGAY = DateTime.Parse(this.txtTHA_NGAY.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.THA_DIADIEM= txtTHA_DIADIEM.Text.Trim();
                obj.THA_GHICHU = txtTHA_GHICHU.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_KQTHA();
                cmdUpdate_KQTHA.Text = "Sửa";
                cmdDelete_kqtha.Text = "Xóa";
            }
        }
        protected void cmdDelete_kqtha_Click(object sender, EventArgs e)
        {
            if (cmdDelete_kqtha.Text == "Hủy")
            {
                cmdUpdate_KQTHA.Text = "Sửa";
                cmdDelete_kqtha.Text = "Xóa";
            }
            else if (cmdDelete_kqtha.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 8;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                ddlTHA_KETQUA.SelectedValue = "0";
                txtTHA_NGAY.Text = "";
                txtTHA_DIADIEM.Text = "";
                txtTHA_GHICHU.Text = "";
                Enable_KQTHA();
                cmdUpdate_KQTHA.Text = "Lưu";
                cmdDelete_kqtha.Text = "Hủy";
            }

            
        }

        protected void cmdUpdateLUUHS_Click(object sender, EventArgs e)
        {
            if (cmdUpdateLUUHS.Text == "Sửa")
            {
                Enable_LUUHS();
                cmdUpdateLUUHS.Text = "Lưu";
                cmdDELETE_LUUHS.Text = "Hủy";
            }
            else if (cmdUpdateLUUHS.Text == "Lưu")
            {

                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 9;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");

                obj.LUUHS_NGUOICHUYEN = Convert.ToDecimal(ddlLUUHS_NGUOICHUYEN_ID.SelectedValue);
                obj.LUUHS_NGAYCHUYEN = DateTime.Parse(this.txtLUUHS_NGAYCHUYEN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.LUUHS_NGUOINHAN = txtLUUHS_NGUOINHAN.Text.Trim();
               
                obj.LUUHS_DONVINHAN = txtLUUHS_DONVINHAN.Text.Trim();
                obj.LUUHS_TINHTRANGHS = ddlLUUHS_TINHTRANGHS.SelectedValue;
               
                obj.LUUHS_GHICHU = txtLUUHS_GHICHU.Text.Trim();

                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);
                //GIAIQUYET_Insert_Update(obj);
                Disable_LUUHS ();
                cmdUpdateLUUHS.Text = "Sửa";
                cmdDELETE_LUUHS.Text = "Xóa";
            }
        }
        protected void cmdDELETE_LUUHS_Click(object sender, EventArgs e)
        {
            if (cmdDELETE_LUUHS.Text == "Hủy")
            {
                cmdUpdateLUUHS.Text = "Sửa";
                cmdDELETE_LUUHS.Text = "Xóa";
            }
            else if (cmdDELETE_LUUHS.Text == "Xóa")
            {
                GDTTT_GIAIQUYET_TUHINH obj = new GDTTT_GIAIQUYET_TUHINH();

                obj.LOAI_UP = 9;
                obj.ID = Convert.ToDecimal(Request["ID"] + "");
                GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                
                oBL.GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(obj);

                txtLUUHS_NGAYCHUYEN.Text = "";
                txtLUUHS_NGUOINHAN.Text = "";
                txtLUUHS_DONVINHAN.Text = "";
                ddlLUUHS_TINHTRANGHS.SelectedValue = "0";
                txtLUUHS_GHICHU.Text = "";

                Enable_LUUHS();
                cmdUpdateLUUHS.Text = "Lưu";
                cmdDELETE_LUUHS.Text = "Hủy";
            }

        }


        void Enable_KLCA()
        {
            txtSOQD_CA.Enabled = txtNgayQD_CA.Enabled = txtNOIDUNG_QD_CA.Enabled = txtNGAYPHCV_VKS.Enabled =txtGHICHUCV_GUI.Enabled  = true;
           
        }
        void Disable_KLCA()
        {
            txtSOQD_CA.Enabled = txtNgayQD_CA.Enabled = txtNOIDUNG_QD_CA.Enabled = txtNGAYPHCV_VKS.Enabled =txtGHICHUCV_GUI.Enabled =  false;
            
        }

        void Enable_KLVKS()
        {
            txtSOQD_VKS.Enabled = txtNGAYQD_VKS.Enabled = txtNGAYTT_VKS.Enabled = txtGHICHU_VKS_TRA.Enabled = true;
        }
        void Disable_KLVKS()
        {
            txtSOQD_VKS.Enabled = txtNGAYQD_VKS.Enabled = txtNGAYTT_VKS.Enabled = txtGHICHU_VKS_TRA.Enabled = false;
        }

        void Enable_CTN()
        {
            txtCTN_SOQĐ.Enabled = txtCTN_NGAYQD.Enabled = txtCTN_NGAYTRA.Enabled = txtCTN_GHICHU.Enabled= true;
        }

        void Disable_CTN()
        {
            txtCTN_SOQĐ.Enabled = txtCTN_NGAYQD.Enabled = txtCTN_NGAYTRA.Enabled = txtCTN_GHICHU.Enabled = false;
        }

        void Enable_CVXM()
        {
            txtSOCVXM.Enabled = txtNGAYCVXM.Enabled = txtNoidungXM.Enabled = true;
        }
        void Disable_CVXM()
        {
            txtSOCVXM.Enabled = txtNGAYCVXM.Enabled = txtNoidungXM.Enabled = false;
        }
        void Enable_KQXM()
        {
            txtNgayKQXM.Enabled = txtKetquaXM.Enabled = true;
        }
        void Disable_KQXM()
        {
            txtNgayKQXM.Enabled = txtKetquaXM.Enabled = false;
        }

       
        void Enable_KQTHA()
        {
            txtTHA_NGAY.Enabled = txtTHA_DIADIEM.Enabled = txtTHA_GHICHU.Enabled = true;
        }
        void Disable_KQTHA()
        {
            txtTHA_NGAY.Enabled = txtTHA_DIADIEM.Enabled = txtTHA_GHICHU.Enabled = false;
        }

        void Enable_LUUHS()
        {
            txtLUUHS_NGAYCHUYEN.Enabled = txtLUUHS_NGUOINHAN.Enabled = txtLUUHS_DONVINHAN.Enabled = txtLUUHS_GHICHU.Enabled = true;
        }
        void Disable_LUUHS()
        {
            txtLUUHS_NGAYCHUYEN.Enabled = txtLUUHS_NGUOINHAN.Enabled = txtLUUHS_DONVINHAN.Enabled = txtLUUHS_GHICHU.Enabled = false;
        }



    }
}