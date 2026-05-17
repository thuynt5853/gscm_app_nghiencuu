using BL.GSTP.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.ThongTinDanhGiaTP
{
    public partial class ThongTinAnHuySua : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropLoaiAn();
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("-- Tất cả --", "TATCA"));
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIAN.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIAN.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIAN.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân và gia đình", ENUM_LOAIAN.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh thương mại", ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIAN.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIAN.AN_PHASAN));
            ddlLoaiAn.Items.Add(new ListItem("Biện pháp xử lý hành chính", ENUM_LOAIAN.BPXLHC));
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            decimal ThamPhanID = Session[ENUM_LOAIAN.AN_GSTP] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP] + "");
            if (ThamPhanID == 0)
            {
                lbthongbao.Text = "Bạn chưa chọn thẩm phán!";
                return;
            }
            if (txtNgayQDBA.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayQDBA.Text) == false)
            {
                lbthongbao.Text = "Ngày QĐ/BA phải theo định dạng (dd/MM/yyyy)!";
                txtNgayQDBA.Focus();
                return;
            }
            string TenVuAn = txtTen.Text.Trim().ToLower(), MaVuAn = txtMa.Text.Trim().ToLower(), AnSuaHuy = ddlAnHuySua.SelectedValue,
                SoQDBA = txtSoQDBA.Text.Trim().ToLower(), NgayQDBA = txtNgayQDBA.Text.Trim(), LoaiAn = ddlLoaiAn.SelectedValue, TrangThai = ddlTrangThai.SelectedValue;

            GSTP_BL bl = new GSTP_BL();
            DataTable tbl = bl.DANHGIA_ANSUAHUY_OFTP(ThamPhanID, TenVuAn, MaVuAn, AnSuaHuy, SoQDBA, NgayQDBA, LoaiAn, TrangThai);
            int Total = 0, pageSize = Convert.ToInt32(hddPageSize.Value);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = tbl.Rows.Count;
            }
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            dgList.PageSize = pageSize;
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 1;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                string[] arr = (e.CommandArgument + "").Split('#');
                decimal ID = arr[0] + "" == "" ? 0 : Convert.ToDecimal(arr[0]);
                hddLoaiAn.Value = arr[4]; hddVuAnID.Value = arr[5];
                hddDanhGiaID.Value = ID + "";
                string LoaiAnShort = arr[6];
                Session["GSTP_CALL_VUAN_INFO"] = hddVuAnID.Value;
                GSTP_DANHGIAANHUYSUA obj = dt.GSTP_DANHGIAANHUYSUA.Where(x => x.ID == ID).FirstOrDefault();
                switch (e.CommandName)
                {
                    case "Sua":
                        pnUpdate.Visible = true; pnThongTin.Visible = false;
                        txtTenVuAn.Text = arr[1]; txtAnSuaHuy.Text = arr[2]; txtLoaiAn.Text = arr[3];
                        if (obj != null)
                        {
                            rdbChuQuanKhachQuan_TP.SelectedValue = obj.TP_DANHGIA + "";
                            txtLyDo_TP.Text = obj.TP_LYDO;
                            rdbChuQuanKhachQuan_UBTP.SelectedValue = obj.UBTP_DANHGIA + "";
                            txtLyDo_UBTP.Text = obj.UBTP_LYDO;
                        }
                        break;
                    case "Xoa":
                        if (obj != null)
                        {
                            dt.GSTP_DANHGIAANHUYSUA.Remove(obj);
                            dt.SaveChanges();
                            hddPageIndex.Value = "1";
                            LoadData();
                            lbthongbao.Text = "Xóa thành công!";
                        }
                        break;
                    case "ChiTiet":
                        switch (LoaiAnShort)
                        {
                            case "AHS":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAHS()");
                                break;
                            case "ADS":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforADS()");
                                break;
                            case "AHN":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAHN()");
                                break;
                            case "AKT":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAKT()");
                                break;
                            case "ALD":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforALD()");
                                break;
                            case "AHC":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAHC()");
                                break;
                            case "APS":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAPS()");
                                break;
                            case "XLHC":
                                Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforBPXLHC()");
                                break;
                        }
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
            try
            {
                ResetControl();
                pnThongTin.Visible = true; pnUpdate.Visible = false;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                if (rdbChuQuanKhachQuan_TP.SelectedValue == "" || rdbChuQuanKhachQuan_UBTP.SelectedValue == "")
                {
                    lbthongbaoUpdate.Text = "Bạn chưa chọn đánh giá khách quan hay chủ quan. Hãy chọn lại!";
                    return;
                }
                if (txtLyDo_TP.Text.Trim() == "")
                {
                    lbthongbaoUpdate.Text = "Bạn chưa nhập lý do. Hãy nhập lại!";
                    txtLyDo_TP.Focus();
                    return;
                }
                if (txtLyDo_UBTP.Text.Trim() == "")
                {
                    lbthongbaoUpdate.Text = "Bạn chưa nhập lý do. Hãy nhập lại!";
                    txtLyDo_UBTP.Focus();
                    return;
                }
                decimal DanhGiaID = Convert.ToDecimal(hddDanhGiaID.Value);
                bool isNew = false;
                GSTP_DANHGIAANHUYSUA obj = dt.GSTP_DANHGIAANHUYSUA.Where(x => x.ID == DanhGiaID).FirstOrDefault();
                if (obj == null)
                {
                    isNew = true;
                    obj = new GSTP_DANHGIAANHUYSUA();
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.NGAYTAO = DateTime.Now;
                }
                else
                {
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.NGAYSUA = DateTime.Now;
                }
                obj.LOAIAN = hddLoaiAn.Value;
                obj.THAMPHANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP] + "");
                obj.TP_DANHGIA = Convert.ToDecimal(rdbChuQuanKhachQuan_TP.SelectedValue);
                obj.TP_LYDO = txtLyDo_TP.Text.Trim();
                obj.UBTP_DANHGIA = Convert.ToDecimal(rdbChuQuanKhachQuan_UBTP.SelectedValue);
                obj.UBTP_LYDO = txtLyDo_UBTP.Text.Trim();
                obj.VUANID = Convert.ToDecimal(hddVuAnID.Value);
                if (isNew)
                {
                    dt.GSTP_DANHGIAANHUYSUA.Add(obj);
                }
                dt.SaveChanges();
                lbthongbaoUpdate.Text = "Lưu thông tin thành công!";
            }
            catch (Exception ex) { lbthongbaoUpdate.Text = ex.Message; }
        }
        private void ResetControl()
        {
            lbthongbao.Text = lbthongbaoUpdate.Text = "";
            rdbChuQuanKhachQuan_TP.ClearSelection();
            txtLyDo_TP.Text = "";
            rdbChuQuanKhachQuan_UBTP.ClearSelection();
            txtLyDo_UBTP.Text = "";
            hddDanhGiaID.Value = "0";
            txtTen.Text = txtMa.Text = txtSoQDBA.Text = txtNgayQDBA.Text = "";
            ddlLoaiAn.SelectedIndex = ddlAnHuySua.SelectedIndex = ddlTrangThai.SelectedIndex = 0;
        }
    }
}