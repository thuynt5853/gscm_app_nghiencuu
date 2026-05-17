using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NLog;

namespace WEB.GSTP.QLAN.AHS.Hoso
{
    public partial class BienPhapNganChan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public static Decimal VuAnID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                {
                    VuAnID = String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                    CurrentYear = DateTime.Now.Year;
                    if (!IsPostBack)
                    {
                        CheckQuyen();
                        LoadCombobox();
                        if (VuAnID > 0)
                            LoadGrid();
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            } catch (Exception ex)
            {
                lstMsgB.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdThemMoi, oPer.TAOMOI);

            //decimal ID = VuAnID;
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();
            NgayXayRaVuAn = oT.NGAYXAYRA + "" == "" ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);
            //NgayXayRaVuAn = ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            if (oT.MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            {
                lstMsgB.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            else if ((oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT) && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            {
                lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //----------------------
            List<AHS_SOTHAM_BANAN> lstBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).ToList();
            if (lstBA != null && lstBA.Count() > 0)
                cmdThemMoi.Visible = false;
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgB.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemMoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        private void LoadCombobox()
        {
            LoadDSBiCan();
            //--------------------------
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.BIENPHAPNGANCHAN);
            dropBienPhapNganChan.Items.Clear();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    dropBienPhapNganChan.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
                    if (!String.IsNullOrEmpty(row["Ma"] + "")
                            && row["Ma"].ToString() == ENUM_AHS_BPNGANCHAN.TAMGIAM)
                        hddBPNC_TamGiam.Value = row["ID"].ToString();
                }
            }

            //=-----------------------------------
            tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAIDONVIQDNGANCHAN);
            dropDV.Items.Clear();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    dropDV.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }

        }
        void LoadDSBiCan()
        {
            VuAnID = String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
            if (lst != null && lst.Count > 0)
            {
                dropBiCan.Items.Clear();
                if (lst.Count > 1)
                    dropBiCan.Items.Add(new ListItem("--------Chọn--------", "0"));
                foreach (AHS_BICANBICAO item in lst)
                    dropBiCan.Items.Add(new ListItem(item.HOTEN, item.ID.ToString()));
            }
        }
        protected void cmdThemMoi_Click(object sender, EventArgs e)
        {
            ResetForm();
        }
        void ResetForm()
        {
            dropBienPhapNganChan.SelectedIndex = dropBiCan.SelectedIndex = dropDV.SelectedIndex = 0;
            txtNgayBatDau.Text = txtNgayKT.Text = "";
            txtSoNgay.Text = string.Empty;
            //  rdHieuLuc.SelectedValue = "0";
            hddID.Value = "";
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            Save();
            ResetForm();
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        void Save()
        {
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            Decimal CurrentID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            AHS_SOTHAM_BIENPHAPNGANCHAN obj = new AHS_SOTHAM_BIENPHAPNGANCHAN();
            try
            {
                if (CurrentID > 0)
                    obj = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.ID == CurrentID).Single<AHS_SOTHAM_BIENPHAPNGANCHAN>();
                else
                    obj = new AHS_SOTHAM_BIENPHAPNGANCHAN();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_BIENPHAPNGANCHAN(); }

            obj.VUANID = VuAnId;
            obj.BICANID = Convert.ToDecimal(dropBiCan.SelectedValue);
            obj.DONVIRAQD = Convert.ToDecimal(dropDV.SelectedValue);
            obj.BIENPHAPNGANCHANID = Convert.ToDecimal(dropBienPhapNganChan.SelectedValue);
            obj.HIEULUC = 1;// Convert.ToInt16(rdHieuLuc.SelectedValue);

            // obj.GHICHU = txtGhiChu.Text.Trim();
            DateTime date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgayBatDau.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBatDau.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYBATDAU = date_temp;

            date_temp = (String.IsNullOrEmpty(txtNgayKT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYKETTHUC = date_temp;

            if (CurrentID > 0)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {

                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                if(obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(obj);
                dt.SaveChanges();
            }
            lstMsgB.Text = "Lưu dữ liệu thành công!";
        }
        #region Load DS 
        public void LoadGrid()
        {
            Decimal vu_an_id = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            AHS_SOTHAM_BIENPHAPNGANCHAN_BL objBL = new AHS_SOTHAM_BIENPHAPNGANCHAN_BL();
            DataTable tbl = objBL.GetByVuAnID(vu_an_id, pageindex, page_size);
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
                //lstMsgB.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
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
            lstMsgB.Text = "";
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    ResetForm();
                    hddID.Value = curr_id + "";
                    LoadInfo(curr_id);
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
                    xoa(curr_id);
                    ResetForm();
                    break;
            }
        }
        private void LoadInfo(decimal CurrentID)
        {
            try
            {
                AHS_SOTHAM_BIENPHAPNGANCHAN obj = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.ID == CurrentID).FirstOrDefault();
                if (obj != null)
                {
                    dropBiCan.SelectedValue = obj.BICANID.ToString();
                    decimal BiCanID = Convert.ToDecimal(dropBiCan.SelectedValue);

                    dropDV.SelectedValue = obj.DONVIRAQD.ToString();
                    dropBienPhapNganChan.SelectedValue = obj.BIENPHAPNGANCHANID.ToString();

                    if (obj.NGAYBATDAU != DateTime.MinValue)
                        txtNgayBatDau.Text = ((DateTime)obj.NGAYBATDAU).ToString("dd/MM/yyyy", cul);

                    if (obj.NGAYKETTHUC != DateTime.MinValue)
                        txtNgayKT.Text = ((DateTime)obj.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
                }
            }
            catch { }
        }
        public void xoa(decimal id)
        {
            AHS_SOTHAM_BIENPHAPNGANCHAN oT = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.ID == id).FirstOrDefault();
            if (oT != null)
            { dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Remove(oT); }
            AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oT.FILEID).FirstOrDefault();
            if (file != null)
            {
                dt.AHS_FILE.Remove(file);
            }
            dt.SaveChanges();
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetForm();
            lstMsgB.Text = "Xóa thành công!";
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                DataRowView rView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                Literal ltrNgayKetThuc = (Literal)e.Item.FindControl("ltrNgayKetThuc");
                string strNgayKetThuc = rView["NgayKetThuc"] + "" == "" ? "" : ((DateTime)rView["NgayKetThuc"]).ToString("dd/MM/yyyy"),
                    strDateMin = DateTime.MinValue.ToString("dd/MM/yyyy");

                if (strNgayKetThuc == strDateMin)
                    ltrNgayKetThuc.Text = "";
                else
                    ltrNgayKetThuc.Text = strNgayKetThuc;
                //int MaGiaiDoanVuAn = (string.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt32(hddGiaiDoanVuAn.Value);
                //if (MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.PHUCTHAM || MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.THULYGDT)
                //{
                //    lblSua.Text = "Chi tiết";
                //    Cls_Comon.SetLinkButton(lbtXoa, false);
                //}
                //if (MaGiaiDoanVuAn != ENUM_GIAIDOANVUAN.HOSO)
                //   lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        #endregion

        protected void txtSoNgay_TextChanged(object sender, EventArgs e)
        {
            //if (dropBienPhapNganChan.SelectedValue != "0"
            //        && dropBienPhapNganChan.SelectedValue == hddBPNC_TamGiam.Value)
            //{
                if (!string.IsNullOrEmpty(txtNgayBatDau.Text))
                {
                    DateTime ngaybatdau = DateTime.Parse(this.txtNgayBatDau.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    int songay = String.IsNullOrEmpty(txtSoNgay.Text.Trim()) ? 0 : Convert.ToInt32(txtSoNgay.Text);
                    DateTime ngaykt = ngaybatdau.AddDays(songay);
                    txtNgayKT.Text = ngaykt.ToString("dd/MM/yyyy", cul);
                }
            //}
        }
    }
}
