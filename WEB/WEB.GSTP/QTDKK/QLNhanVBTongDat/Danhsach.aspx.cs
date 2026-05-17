using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;
using System.Data;
using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;

namespace WEB.GSTP.QTDKK.QLNhanVBTongDat
{
    public partial class Danhsach : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    LoadDanhSach();
                }
                dropTucachToTung.Attributes.Add("onchange", "change_control();");
                dropTrangThai.Attributes.Add("onchange", "change_control();");
            }
            else Response.Redirect("/login.aspx");
        }
        void LoadDrop()
        {
            String MaTuCachKoSD = "$TGTTDS_01$TGTTDS_02$TGTTDS_08$TGTTDS_09$";
            dropTucachToTung.Items.Clear();
            string temp = "";
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTucachToTung.Items.Add(new ListItem("Nguyên đơn", "NGUYENDON"));
                dropTucachToTung.Items.Add(new ListItem("Bị đơn", "BIDON"));
                dropTucachToTung.Items.Add(new ListItem("Người có quyền và NVLQ", "QUYENNVLQ"));
                dropTucachToTung.Items.Add(new ListItem("Người được ủy quyền", "DUOCUYQUYEN"));
                foreach (DataRow row in tbl.Rows)
                {
                    temp = "$" + row["MA"].ToString() + "$";
                    if (!MaTuCachKoSD.Contains(temp))
                        dropTucachToTung.Items.Add(new ListItem(row["Ten"].ToString(), row["MA"].ToString()));
                }
            }
            //--------------------
            dropTrangThai.Items.Clear();
            dropTrangThai.Items.Add(new ListItem("---Tất cả---", "4" ));
            dropTrangThai.Items.Add(new ListItem("Đang giao dịch", "1"));
            dropTrangThai.Items.Add(new ListItem("Đợi duyệt", "0"));
            dropTrangThai.Items.Add(new ListItem("Ngừng giao dịch", "2"));
            dropTrangThai.Items.Add(new ListItem("Tạm dừng", "3"));
        }
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDanhSach();
        }
        //cmdIn_Click
        protected void cmdIn_Click(object sender, EventArgs e)
        {
            //lấy toàn bộ data để in
            foreach (RepeaterItem item in rpt.Items)
            {
                CheckBox checkBox = (CheckBox)item.FindControl("chkChon");
                if (checkBox.Checked)
                {

                }
            }
        }
        //------------------------
        #region Load DS
        public void LoadDanhSach()
        {
            string tucachtt = dropTucachToTung.SelectedValue;
            string vuviec = txtVuViec.Text.Trim();
            decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); //(string.IsNullOrEmpty(hddToaAnID.Value)) ? 0 : Convert.ToInt32(hddToaAnID.Value);
            string textsearch = txtVuViec.Text.Trim();
            int trangthai =Convert.ToInt16( dropTrangThai.SelectedValue);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            string tenduongsu = txtTenDuongSu.Text.Trim();
            string cmnd = txtCMND.Text.Trim();
            string madangky = txtMaDangKy.Text.Trim();
            string quanHePhapLuat = txtQuanHePhapLuat.Text;
            string email = txtEmail.Text;
            string sodienthoai = txtSoDienThoai.Text;
            
            DataTable tbl = null;
            DOnKK_User_DKNhanVB_BL oBL = new DOnKK_User_DKNhanVB_BL();

            tbl = oBL.GetListDKByToaAn(toa_an_id, tucachtt, tenduongsu, cmnd, madangky ,textsearch, trangthai, dFrom, dTo, quanHePhapLuat, email, sodienthoai, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingTop.Visible = pnPagingBottom.Visible = rpt.Visible = true;
            }
            else
                pnPagingTop.Visible = pnPagingBottom.Visible = rpt.Visible = false;
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;

                int trangthai = Convert.ToInt16(rv["TrangThai"] + "");               
                LinkButton lbtDuyet = (LinkButton)e.Item.FindControl("lbtDuyet");
                LinkButton lbtMo = (LinkButton)e.Item.FindControl("lbtMo");
                LinkButton lbtDong = (LinkButton)e.Item.FindControl("lbtDong");
                //0:chưa dc duoc duyet, 1: da duyet
                switch (trangthai)
                {
                    //chờ duyệt
                    case 0:
                        lbtDuyet.Visible = true;
                        lbtMo.Visible = lbtDong.Visible = false;

                        break;
                        //Đang giao dịch
                    case 1:
                        lbtDong.Visible = true;
                        lbtMo.Visible = lbtDuyet.Visible = false;
                        break;
                        //Ngừng giao dịch
                    case 2:
                        lbtMo.Visible = true;
                        lbtDong.Visible = lbtDuyet.Visible = false;
                        break;
                    //Tạm dừng giao dịch
                    case 3:
                        lbtDuyet.Visible = false;
                        lbtMo.Visible = lbtDong.Visible = true;
                        break;
                }
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Decimal DangKyID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "lbtDuyet":
                    Duyet(DangKyID);
                    break;
                case "lbtMo":
                    Mo(DangKyID);
                    break;
                case "lbtDong":
                    Dong(DangKyID);
                    break;
            }
        }
        void Dong(Decimal DangKyID)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_LyDoVbTongDat('"+DangKyID+"');");
            //DONKK_USER_DKNHANVB obj = dt.DONKK_USER_DKNHANVB.Where(x => x.ID == DangKyID).Single<DONKK_USER_DKNHANVB>();
            //if (obj != null)
            //{
            //    obj.TRANGTHAI = 2;
            //    dt.SaveChanges();
            //    string msg = "Văn bản ngừng giao dịch thành công!";                
            //    string msg = "Văn bản ngừng giao dịch thành công!";                
            //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo",msg);
            //    hddPageIndex.Value = "1";
            //    LoadDanhSach();
            //}
        }

        public void Mo(Decimal DangKyID)
        {
            //chuyển sang trạng thái đang giao dịch
            DONKK_USER_DKNHANVB obj = dt.DONKK_USER_DKNHANVB.Where(x => x.ID == DangKyID).Single<DONKK_USER_DKNHANVB>();
            if (obj != null)
            {
                obj.TRANGTHAI = 1;
                dt.SaveChanges();
                string msg = "Văn bản được mở thành công!";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                hddPageIndex.Value = "1";
                LoadDanhSach();
            }
        }

        public void Duyet(Decimal DangKyID)
        {
            //chuyển sang trạng thái đang giao dịch
            DONKK_USER_DKNHANVB obj = dt.DONKK_USER_DKNHANVB.Where(x => x.ID == DangKyID).Single<DONKK_USER_DKNHANVB>();
            if (obj != null)
            {
                obj.TRANGTHAI = 1;
                dt.SaveChanges();
                string msg = "Văn bản được duyệt thành công!";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                hddPageIndex.Value = "1";
                LoadDanhSach();
            }
        }

        #region phan trang
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDanhSach();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDanhSach();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDanhSach();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDanhSach();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDanhSach();
        }

        #endregion

        #endregion

    }
}