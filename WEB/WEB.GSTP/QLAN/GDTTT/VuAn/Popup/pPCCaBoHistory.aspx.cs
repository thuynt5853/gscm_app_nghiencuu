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

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pPCCaBoHistory : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal CurrentUserID = 0;
        String SessionName = "GDTTT_ReportPL".ToUpper();
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    if (VuAnID > 0)
                    {
                        try {
                            LoadThongTinVuAn(VuAnID);
                            LoadGrid();
                        } catch(Exception exx) {  }
                    }
                }
            }
        }
       
        void LoadThongTinVuAn(Decimal VuAnID)
        {
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
                else
                {
                    txtTenVuan.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

                hddVuAn_ToaAnID.Value = oT.TOAPHUCTHAMID + "";
                //----------------------------------
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);                
            }
        }
        void LoadDuongSu(Decimal VuAnID,string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach(DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
          
        //---------------------------------------
        #region Load ds
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            DataTable tbl = objBL.GDTTT_PCCanBoHistory_GetByVuAn(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
            }
            else
                rpt.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            if (e.CommandName== "Xoa") { 
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    xoa(curr_id);
            }
        }
     
        void xoa(decimal id)
        {
            GDTTT_VUAN_PHANCONGCB_HISTORY oND = dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Remove(oND);
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadGrid();
                lbthongbao.Text = "Xóa thành công!";
            }
        }

        protected void cmdPrinBM_Click(object sender, EventArgs e)
        {
            String SessionName = "GDTTT_ReportPL".ToUpper();
            Session[SessionName] = null;
            Session[SS_TK.TENBAOCAO] = "In danh sach luân chuyển hồ sơ";

            Decimal CurrentID = 0;
            try
            {
                CurrentID = Convert.ToDecimal(hddCurrID.Value);
                String JS = "window.open('/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso&loai=bm&vID=" + Request["vID"]
                    +"&hsID=" + CurrentID + "'"
                    + ", '', 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=950, height=500, top=100, left=10')";
               
                Cls_Comon.CallFunctionJS(this, this.GetType(), JS);                
            }
            catch (Exception exx) { }
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //String textsearch = txtTextSearch.Text.Trim();
            //int page_size = 2000000000;
            //String SessionName = "GDTTT_ReportPL".ToUpper();
            //Session[SS_TK.TENBAOCAO] = "Quản lý hồ sơ";

            //GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();            
            //DataTable tblData =  objBL.GetAllPaging(VuAnID,  1, page_size);
            //if (tblData != null && tblData.Rows.Count > 0)
            //    Session[SessionName] = tblData;
        }
        #endregion
   }
}