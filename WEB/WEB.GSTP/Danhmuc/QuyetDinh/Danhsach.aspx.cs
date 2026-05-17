using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.Danhmuc;
using System.Data;
using System.Globalization;

namespace WEB.GSTP.Danhmuc.QuyetDinh
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddCountAllItem.Value = GetListLoaiQD().Count.ToString();
                    hddPageIndex.Value = "1";
                    LoadGrid();

                    FillThutu(Convert.ToInt32(hddCountAllItem.Value) + 1);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(btnNew, oPer.TAOMOI);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal LoaiQdID = Convert.ToDecimal(hddLoaiQdID.Value);
                bool isNew = false;
                string Ma = txtMa.Text.Trim(), Ten = txtTen.Text.Trim();
                if (!ValidateData(Ma, Ten, LoaiQdID))
                {
                    return;
                }
                DM_QD_LOAI LoaiQD = dt.DM_QD_LOAI.Where(x => x.ID == LoaiQdID).FirstOrDefault<DM_QD_LOAI>();
                if (LoaiQD == null)
                {
                    isNew = true;
                    LoaiQD = new DM_QD_LOAI();
                    LoaiQD.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    LoaiQD.NGAYTAO = DateTime.Now;
                }
                else
                {
                    LoaiQD.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    LoaiQD.NGAYSUA = DateTime.Now;
                }
                LoaiQD.MA = Ma;
                LoaiQD.TEN = Ten;
                LoaiQD.THUTU = Convert.ToDecimal(DropThuTu.SelectedValue);
                LoaiQD.ISHINHSU = chkHinhSu.Checked ? 1 : 0;
                LoaiQD.ISDANSU = chkDanSu.Checked ? 1 : 0;
                LoaiQD.ISHNGD = chkHonNhanGD.Checked ? 1 : 0;
                LoaiQD.ISKDTM = chkKDTM.Checked ? 1 : 0;
                LoaiQD.ISLAODONG = chkLaoDong.Checked ? 1 : 0;
                LoaiQD.ISHANHCHINH = chkHanhChinh.Checked ? 1 : 0;
                LoaiQD.HIEULUC = chkHieuluc.Checked ? 1 : 0;
                LoaiQD.ISDUONGSUYEUCAU = chkDuongsuYC.Checked ? 1 : 0;
                LoaiQD.ISPHASAN= chkPhasan.Checked ? 1 : 0;
                LoaiQD.ISXLHC = chkXLHC.Checked ? 1 : 0;

                if (isNew)
                {
                    dt.DM_QD_LOAI.Add(LoaiQD);
                    hddCountAllItem.Value = (Convert.ToInt32(hddCountAllItem.Value) + 1).ToString();
                }
                dt.SaveChanges();
                // Update các quyết định của loại quyết định nếu có
                UpdateDM_QD_QUYETDINH(LoaiQD);
                Resetcontrol();
                hddPageIndex.Value = "1";
                LoadGrid();
                if (isNew)
                {
                    lbthongbao.Text = "Thêm mới thành công!";
                }
                else
                {
                    lbthongbao.Text = "Lưu thành công!";
                }
                FillThutu(Convert.ToInt32(hddCountAllItem.Value) + 1);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void UpdateDM_QD_QUYETDINH(DM_QD_LOAI LoaiQD)
        {
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == LoaiQD.ID).ToList<DM_QD_QUYETDINH>();
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_QD_QUYETDINH item in lst)
                {
                    item.ISHINHSU = LoaiQD.ISHINHSU;
                    item.ISDANSU = LoaiQD.ISDANSU;
                    item.ISHNGD = LoaiQD.ISHNGD;
                    item.ISKDTM = LoaiQD.ISKDTM;
                    item.ISLAODONG = LoaiQD.ISLAODONG;
                    item.ISHANHCHINH = LoaiQD.ISHANHCHINH;

                    item.ISPHASAN = LoaiQD.ISPHASAN;
                    item.ISXLHC = LoaiQD.ISXLHC;

                }
                dt.SaveChanges();
            }
        }
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            string textKey = txttimkiem.Text.Trim().ToLower();
            int pageSize = Convert.ToInt32(hddPageSize.Value);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value);
            DM_QD_LOAI_BL oBL = new DM_QD_LOAI_BL();
            DataTable tbl = oBL.Search(textKey, 2, pageIndex, pageSize);
            int count_all = 0;
            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");  //tbl.Rows.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) 
                                                        + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = pageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            txtTen.Text = "";
            txtMa.Text = "";
            chkHinhSu.Checked = chkDanSu.Checked = chkHonNhanGD.Checked = chkKDTM.Checked = chkLaoDong.Checked = chkHanhChinh.Checked = chkHieuluc.Checked=chkPhasan.Checked=chkXLHC.Checked = false;
            FillThutu(Convert.ToInt32(hddCountAllItem.Value) + 1);
            hddLoaiQdID.Value = "0";
        }
        public void Xoa(decimal id)
        {
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == id).ToList();
            if (lst != null && lst.Count > 0)
            {
                lbthongbao.Text = "Loại quyết định này đã có dữ liệu, không thể xóa được.";
                return;
            }
            DM_QD_LOAI oT = dt.DM_QD_LOAI.Where(x => x.ID == id).FirstOrDefault<DM_QD_LOAI>();
            dt.DM_QD_LOAI.Remove(oT);
            dt.SaveChanges();
            hddCountAllItem.Value = (Convert.ToInt32(hddCountAllItem.Value) - 1).ToString();
            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
            FillThutu(Convert.ToInt32(hddCountAllItem.Value) + 1);
            lbthongbao.Text = "Xóa thành công!";
        }
        public void Loadedit(decimal ID)
        {
            DM_QD_LOAI oT = dt.DM_QD_LOAI.Where(x => x.ID == ID).FirstOrDefault<DM_QD_LOAI>();
            if (oT == null) return;
            hddLoaiQdID.Value = ID.ToString();
            FillThutu(Convert.ToInt32(hddCountAllItem.Value) + 1);
            txtTen.Text = oT.TEN;
            txtMa.Text = oT.MA;
            DropThuTu.SelectedValue = oT.THUTU.ToString();
            chkHinhSu.Checked = string.IsNullOrEmpty(oT.ISHINHSU + "") ? false : Convert.ToBoolean(oT.ISHINHSU);
            chkDanSu.Checked = string.IsNullOrEmpty(oT.ISDANSU + "") ? false : Convert.ToBoolean(oT.ISDANSU);
            chkHonNhanGD.Checked = string.IsNullOrEmpty(oT.ISHNGD + "") ? false : Convert.ToBoolean(oT.ISHNGD);
            chkKDTM.Checked = string.IsNullOrEmpty(oT.ISKDTM + "") ? false : Convert.ToBoolean(oT.ISKDTM);
            chkLaoDong.Checked = string.IsNullOrEmpty(oT.ISLAODONG + "") ? false : Convert.ToBoolean(oT.ISLAODONG);
            chkHanhChinh.Checked = string.IsNullOrEmpty(oT.ISHANHCHINH + "") ? false : Convert.ToBoolean(oT.ISHANHCHINH);
            chkHieuluc.Checked = string.IsNullOrEmpty(oT.HIEULUC + "") ? false : Convert.ToBoolean(oT.HIEULUC);
            chkDuongsuYC.Checked = string.IsNullOrEmpty(oT.ISDUONGSUYEUCAU + "") ? false : Convert.ToBoolean(oT.ISDUONGSUYEUCAU);
            chkPhasan.Checked = string.IsNullOrEmpty(oT.ISPHASAN + "") ? false : Convert.ToBoolean(oT.ISPHASAN);
            chkXLHC.Checked = string.IsNullOrEmpty(oT.ISXLHC + "") ? false : Convert.ToBoolean(oT.ISXLHC);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal LoaiQdID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    Loadedit(LoaiQdID);
                    break;
                case "Xoa":
                    Xoa(LoaiQdID);
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnNew_Click(object sender, EventArgs e)
        {
            try
            {
                Resetcontrol();
                FillThutu(GetListLoaiQD().Count + 1);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void FillThutu(int iCount)
        {
            DropThuTu.Items.Clear();
            if (iCount > 0)
            {
                for (int i = 1; i <= iCount; i++)
                {
                    DropThuTu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                DropThuTu.SelectedIndex = iCount - 1;
            }
            else
            {
                DropThuTu.Items.Add(new ListItem("1", "1"));
            }
        }
        public List<DM_QD_LOAI> GetListLoaiQD()
        {
            return dt.DM_QD_LOAI.ToList();
        }
        private bool ValidateData(string Ma, string Ten, decimal ID)
        {
            int lengthMa = Ma.Length;
            if (lengthMa == 0 || lengthMa > 20)
            {
                lbthongbao.Text = "Mã loại quyết định không được trống hoặc lớn hơn 20 ký tự. Hãy nhập lại!";
                return false;
            }
            int lengthTen = Ten.Length;
            if (lengthTen == 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Mã loại quyết định không được trống hoặc lớn hơn 250 ký tự. Hãy nhập lại!";
                return false;
            }
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI.Where(x => x.MA.ToLower() == Ma.ToLower()).FirstOrDefault<DM_QD_LOAI>();
            if (loaiQD != null)
            {
                if (loaiQD.ID != ID)
                {
                    lbthongbao.Text = "Mã loại quyết định này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            loaiQD = dt.DM_QD_LOAI.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_QD_LOAI>();
            if (loaiQD != null)
            {
                if (loaiQD.ID != ID)
                {
                    lbthongbao.Text = "Tên loại quyết định này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            return true;
        }
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            int ColIDIndex = 0;
            decimal loaiQdID = 0;
            DM_QD_LOAI qd = new DM_QD_LOAI();
            foreach (DataGridItem oItem in dgList.Items)
            {
                loaiQdID = Convert.ToDecimal(oItem.Cells[ColIDIndex].Text);
                qd = dt.DM_QD_LOAI.Where(x => x.ID == loaiQdID).FirstOrDefault<DM_QD_LOAI>();
                //  DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                //qd.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                TextBox txtThuTu = (TextBox)oItem.FindControl("txtThuTu");
                qd.THUTU = Convert.ToInt32(txtThuTu.Text);
                qd.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                qd.NGAYSUA = DateTime.Now;
                dt.SaveChanges();
            }
            hddPageIndex.Value = "1";
            LoadGrid();
        }
    }
}