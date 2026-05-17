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

namespace WEB.GSTP.QLAN.AHS.Hoso.Popup
{
    public partial class pBienPhapNganChan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                    if (VuAnID > 0)
                    {
                        LoadCombobox();
                        LoadGrid();

                        //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                        //Cls_Comon.SetButton(cmdThemMoi, oPer.TAOMOI);
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lstMsgT.Text = lstMsgB.Text = Result;
                            Cls_Comon.SetButton(cmdUpdate, false);
                            return;
                        }
                    }
                    else
                        Response.Redirect("/Login.aspx");
                } catch (Exception ex)
                {
                    lstMsgT.Text = lstMsgB.Text = ENUM_MESSAGE.SERVER_ERROR;
                    logger.Error("loi xay ra: " + ex);
                }
            }
        }


        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void LoadCombobox()
        {
            List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
            if (lstBC != null && lstBC.Count > 0)
            {
                dropBiCao.Items.Clear();
                foreach (AHS_BICANBICAO obj in lstBC)
                    dropBiCao.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));
                try
                {
                    if (Request["bID"] != null)
                        dropBiCao.SelectedValue = Request["bID"] + "";
                }
                catch (Exception ex) { }
            }
            //--------------------------
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.BIENPHAPNGANCHAN);

            dropBienPhapNganChan.Items.Clear();
            // dropBienPhapNganChan.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    dropBienPhapNganChan.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }

            //=-----------------------------------
            tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAIDONVIQDNGANCHAN);
            dropDV.Items.Clear();
            // dropDV.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    dropDV.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
       
        protected void cmdThemMoi_Click(object sender, EventArgs e)
        {
            ResetForm();
        }
        void ResetForm()
        {
            dropBienPhapNganChan.SelectedIndex =dropBienPhapNganChan.SelectedIndex = -1;
             txtNgayBatDau.Text = txtNgayKT.Text = "";
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
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
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

            obj.VUANID = VuAnID;
            obj.BICANID = Convert.ToDecimal(Request["bID"]+"");
            obj.DONVIRAQD = Convert.ToDecimal(dropDV.SelectedValue);
            obj.BIENPHAPNGANCHANID = Convert.ToDecimal(dropBienPhapNganChan.SelectedValue);
            obj.HIEULUC = 1;// Convert.ToInt16(rdHieuLuc.SelectedValue);

          //  obj.GHICHU = txtGhiChu.Text.Trim();
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
                // insert toa_gq_id
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
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            AHS_SOTHAM_BIENPHAPNGANCHAN_BL objBL = new AHS_SOTHAM_BIENPHAPNGANCHAN_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, pageindex, page_size);
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
            //switch (e.CommandName)
            //{
                //case "Sua":
                //    ResetForm();
                //    hddID.Value = curr_id + "";
                //    LoadInfo(curr_id);
                //    break;
                //case "Xoa":
                //    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //    if (oPer.XOA == false)
                //    {
                //        lstMsgB.Text = "Bạn không có quyền xóa!";
                //        return;
                //    }
                //    xoa(curr_id);
                //    ResetForm();
                //    break;
            //}
        }
        private void LoadInfo(decimal CurrentID)
        {
            AHS_SOTHAM_BIENPHAPNGANCHAN obj = null;
            try
            {
                obj = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.ID == CurrentID).SingleOrDefault();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {
                
                dropDV.SelectedValue = obj.DONVIRAQD.ToString();
                dropBienPhapNganChan.SelectedValue = obj.BIENPHAPNGANCHANID.ToString();

                if (obj.NGAYBATDAU != DateTime.MinValue)
                    txtNgayBatDau.Text = ((DateTime)obj.NGAYBATDAU).ToString("dd/MM/yyyy", cul);

                if (obj.NGAYKETTHUC != DateTime.MinValue)
                    txtNgayKT.Text = ((DateTime)obj.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);

               // txtGhiChu.Text = obj.GHICHU + "";
            }
        }
        public void xoa(decimal id)
        {
            AHS_SOTHAM_BIENPHAPNGANCHAN oT = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Remove(oT);
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
                //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                //{
                //    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                //    Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                //    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                //}
            }
        }
        #endregion
    }
}
