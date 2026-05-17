using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
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
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class pp_ToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal don_id = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hddBiCaoID.Value = Request["duongsuid"] + "";
                don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                hddVuAnID.Value = Session["DONID_CC"] + "";
                LoadDropToiDanh(dropBiCao_ToiDanh);
                LoadDsToiDanh(Convert.ToDecimal(hddBiCaoID.Value));
            }
        }
        private void LoadDropToiDanh(DropDownList dropToiDanh)
        {
            string session_name = "HS_DropToiDanh";
            dropToiDanh.Items.Clear();
            GDTTT_APP_BL oBL = new GDTTT_APP_BL();
            DataTable tbl = new DataTable();
            //-------------
            tbl = oBL.DieuLuat_ToiDanh_Thongke();
            if (Session[session_name] == null)
            {
                tbl = oBL.DieuLuat_ToiDanh_Thongke();
                Session[session_name] = tbl;
            }
            else
                tbl = (DataTable)(Session[session_name]);

            dropToiDanh.DataSource = tbl;
            dropToiDanh.DataTextField = "TENTOIDANH";
            dropToiDanh.DataValueField = "ID";
            dropToiDanh.DataBind();
            dropToiDanh.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        protected void lkBiCao_SaveToiDanh_Click(object sender, EventArgs e)
        {
            Decimal DuongSuID = 0;
            if (dropBiCao_ToiDanh.SelectedValue != "0")
            {
                DuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
                UpdateToiDanhChoDS(DuongSuID);
                lttMsgBC.Text = "Thêm tội danh cho bị cáo thành công!";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent_td();");
            }
            else if (dropBiCao_ToiDanh.SelectedValue == "0")
            {
                lttMsgBC.Text = "Bạn phải chọn tội danh";
            }
        }
        void UpdateToiDanhChoDS(Decimal DuongSuID)
        {
            //------------------------------
            GDTTT_DON_DUONGSU_CC obj_ds = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == DuongSuID).Single<GDTTT_DON_DUONGSU_CC>();
            decimal currtoidanhId = Convert.ToDecimal(dropBiCao_ToiDanh.SelectedValue);
            List<GDTTT_DON_DUONGSU_TOIDANH_CC> lst = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x =>x.DUONGSUID == DuongSuID
                                                                                            && x.TOIDANHID == currtoidanhId).ToList();
            if (lst == null || lst.Count == 0)
            {
                    GDTTT_DON_DUONGSU_TOIDANH_CC obj = new GDTTT_DON_DUONGSU_TOIDANH_CC();
                    obj.DUONGSUID = DuongSuID;
                    obj.DONID = obj_ds.DONID;
                    obj.TOIDANHID = currtoidanhId;
                    obj.TENTOIDANH = dropBiCao_ToiDanh.SelectedItem.Text.Trim();
                    dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Add(obj);
                    dt.SaveChanges();
                    lttMsgBC.Text = "Thêm tội danh thành công";
                    //----------------
                    UpdateListToiDanh_BiCao(DuongSuID);
                    //-------------------
                    dropBiCao_ToiDanh.SelectedIndex = 0;
                    LoadDsToiDanh(DuongSuID);
            }
        }
        void UpdateListToiDanh_BiCao(Decimal DuongSuID)
        {
            don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
            hddVuAnID.Value = Session["DONID_CC"] + "";
            // -------
            String StrToiDanh = "";

            GDTTT_DON_DUONGSU_CC oBC = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == DuongSuID).Single();
            List<GDTTT_DON_DUONGSU_TOIDANH_CC> lst = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == don_id
                                                                                         && x.DUONGSUID == DuongSuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_DON_DUONGSU_TOIDANH_CC oTD in lst)
                {
                    StrToiDanh += (String.IsNullOrEmpty(StrToiDanh + "")) ? "" : "; ";
                    StrToiDanh += oTD.TENTOIDANH;
                }
            }
            oBC.HS_TENTOIDANH = StrToiDanh;
            dt.SaveChanges();
        }
        void LoadDsToiDanh(Decimal DuongSuID)
        {
            don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
            hddVuAnID.Value = Session["DONID_CC"] + "";
            // -------
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            List<GDTTT_DON_DUONGSU_TOIDANH_CC> lst = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == CurrVuAnID
                                                                                         && x.DUONGSUID == DuongSuID
                                                                                      ).ToList();
            if (lst != null && lst.Count > 0)
            {
                rptToiDanh.DataSource = lst;
                rptToiDanh.DataBind();
                rptToiDanh.Visible = true;
            }
            else
            {
                rptToiDanh.DataSource = null;
                rptToiDanh.DataBind();
                rptToiDanh.Visible = false;
            }
        }
        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaToiDanh(curr_id);
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent_td();");
                    //Update_TenVuAn(null);
                    break;
            }
        }
        void XoaToiDanh(Decimal currID)
        {
            Decimal DuongSuID = 0;
            GDTTT_DON_DUONGSU_TOIDANH_CC item = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.ID == currID).Single();
            if (item != null)
            {
                DuongSuID = (Decimal)item.DUONGSUID;
                dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Remove(item);
                dt.SaveChanges();

                UpdateListToiDanh_BiCao(DuongSuID);
                LoadDsToiDanh(DuongSuID);
                //LoadDanhSachBiCao();
                lttMsgBC.Text = "Xóa tội danh thành công";
            }
        }
    }
}