using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.QLAN;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.Hoso
{
    public partial class DsBiCao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        { if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
           {
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                if (!IsPostBack)
                {
                    if (VuAnID > 0)
                    {
                        CheckQuyen();
                        LoadGrid();
                    }
                }
            }
        }

        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            //Cls_Comon.SetButton(cmdThemMoi, oPer.TAOMOI);

            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            int ma_gd = (int)oT.MAGIAIDOAN;
            hddGiaiDoanVuAn.Value = ma_gd.ToString();

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                hddShowCommand.Value = "False";
                return;
            }
            if (ma_gd == (int)ENUM_GIAIDOANVUAN.DINHCHI && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            {
                lstMsgB.Text = "Vụ án đã bị đình chỉ, không được sửa đổi !";
                //Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }            
            else if ((ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT) && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            {
                lstMsgB.Text = "Vụ án đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                //Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            //----------------------
            List<AHS_SOTHAM_BANAN> lstBA = dt.AHS_SOTHAM_BANAN.Where(x=>x.VUANID == VuAnID).ToList();
            if (lstBA != null && lstBA.Count() > 0 && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            {
                lstMsgB.Text = "Vụ án đã đã có bản án, không được sửa đổi !";
                //Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgB.Text = Result;
                //Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        #region Load DS bi cao
        public void LoadGrid()
        {
            VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            string textsearch = txtKey.Text.Trim();

            /* GTEL-DUCPH 18-09-2025 15h40 Viết hàm mới lấy thêm trạng thái xác thực của bị can*/

            //AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
            //DataTable tbl = objBL.GetAllPaging(VuAnID, textsearch, pageindex, page_size);
            AHS_BICANBICAO_NC_BL objBL = new AHS_BICANBICAO_NC_BL();
            DataTable tbl = objBL.AHS_BICAO_GETALL_BY_VUANID_SEARCH(VuAnID,textsearch, pageindex, page_size);
            /* END GTEL-DUCPH 18-09-2025 15h40 Viết hàm mới lấy thêm trạng thái xác thực của bị can*/

           
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                // lstMsgB.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        #endregion


        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    string popupUrl = "/QLAN/AHS/Hoso/popup/pBiCao.aspx?hsID=" + VuAnID + "&bID=" + curr_id;
                    string script = "window.open('" + popupUrl + "', 'Cập nhật thông tin bị can', 'width=950,height=650');";
                    
                    ClientScript.RegisterStartupScript(this.GetType(), "OpenPopup", script, true);

                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lstMsgB.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstMsgB.Text = Result;
                        return;
                    }
                    xoa_bi_can(curr_id);
                    break;
                case "History":  // GTEL-DUCPH 18-09-2025: Thêm command để xem lịch sử sửa đổi của bị can
                    string popupHisUrl = "/QLAN/AHS/Hoso/popup/pHisBiCao.aspx?biCanID=" + curr_id;
                    string scriptHis = "window.open('" + popupHisUrl + "', 'Lịch sử Cập nhật thông tin bị can', 'width=950,height=650');";

                    ClientScript.RegisterStartupScript(this.GetType(), "OpenPopup", scriptHis, true);
                    break;
            }
        }
        public void xoa_bi_can(decimal id)
        {
            //---------nhan than cua bi cao------
            List<AHS_BICAN_NHANTHAN> lst = dt.AHS_BICAN_NHANTHAN.Where(x => x.BICANID == id).ToList<AHS_BICAN_NHANTHAN>();
            if (lst != null && lst.Count>0)
            {
                foreach(AHS_BICAN_NHANTHAN obj in lst)
                    dt.AHS_BICAN_NHANTHAN.Remove(obj);
            }
            //---------Toi danh tuong ung --------------
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lstToiDanh = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
            if (lstToiDanh != null && lstToiDanh.Count > 0)
            {
                foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT objTD in lstToiDanh)
                    dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(objTD);
            }
            //---------Bien phap nc----------
            List<AHS_SOTHAM_BIENPHAPNGANCHAN> lstNganChan = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
            if (lstNganChan != null && lstNganChan.Count > 0)
            {
                foreach (AHS_SOTHAM_BIENPHAPNGANCHAN objNC in lstNganChan)
                    dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Remove(objNC);
            }
            //--------Bi cao---------------
            AHS_BICANBICAO oT = dt.AHS_BICANBICAO.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_BICANBICAO.Remove(oT);
            //------------------------
            dt.SaveChanges();

            //------------------------------------
            hddPageIndex.Value = "1";
            LoadGrid();
            lstMsgB.Text = "Xóa thành công!";
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
 
                string GDTAOHS = rowView["GDTAOHS"] + "";
                if (GDTAOHS == "1")
                {
                    lbtXoa.Visible = false;
                }
                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                int IsAnST = (string.IsNullOrEmpty(rowView["CheckDelete"] + "")) ? 0 : Convert.ToInt16(rowView["CheckDelete"] + "");
                if (IsAnST > 0)
                    lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                AHS_SOTHAM_BANAN BA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if(BA != null)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lstMsgB.Text = "Đã có bản án, quyết định kết thúc vụ án!";
                }
                DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
                DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lstMsgB.Text = "Đã có bản án, quyết định kết thúc vụ án!";
                }
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }
        #endregion

        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid();
        }
    }
}