<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
AutoEventWireup="true" CodeBehind="DuongSu.aspx.cs"
Inherits="WEB.GSTP.QLAN.AHN.Hoso.DuongSu" %> <%@ Register
Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content
  ID="Content2"
  ContentPlaceHolderID="ContentPlaceHolder1"
  runat="server"
>
  <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
  <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
  <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
  <asp:HiddenField ID="hdTrangThaiXacThuc" runat="server"  Value="0" />
  <asp:HiddenField ID="hidNoiSongHuyen" runat="server" ClientIDMode="Static" />

  <div class="box">
    <div class="box_nd">
      <div class="boxchung">
        <h4 class="tleboxchung">Thông tin đương sự</h4>
        <div class="boder" style="padding: 10px">
          <table class="table1">
            <tr>
              <td style="width: 115px">
                Đương sự là<span class="batbuoc">(*)</span>
              </td>
              <td style="width: 260px">
                <asp:DropDownList
                  ID="ddlLoaiNguyendon"
                  CssClass="chosen-select"
                  runat="server"
                  Width="250px"
                  AutoPostBack="True"
                  OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged"
                >
                  <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                  <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                  <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                </asp:DropDownList>
              </td>
              <td style="width: 75px">
                Tư cách tố tụng<span class="batbuoc">(*)</span>
              </td>
              <td>
                <asp:DropDownList
                  ID="ddlTucachTotung"
                  CssClass="chosen-select"
                  runat="server"
                  Width="250px"
                ></asp:DropDownList>
              </td>
            </tr>
            <tr>
              <td>Tên đương sự<span class="batbuoc">(*)</span></td>
              <td>
                <asp:TextBox
                  ID="txtTennguyendon"
                  CssClass="user"
                  runat="server"
                  Width="242px"   ClientIDMode="Static"
                ></asp:TextBox>
              </td>
                <td>Ngày sinh</td>
                <td>
                  <asp:TextBox
                    ID="txtND_Ngaysinh"
                    runat="server"
                    CssClass="user"
                    Width="65px"
                    MaxLength="10"
                    AutoPostBack="True"
                    OnTextChanged="txtND_Ngaysinh_TextChanged"  ClientIDMode="Static"
                  ></asp:TextBox>
                  <cc1:CalendarExtender
                    ID="CalendarExtender2"
                    runat="server"
                    TargetControlID="txtND_Ngaysinh"
                    Format="dd/MM/yyyy"
                    Enabled="true"
                  />
                  <cc1:MaskedEditExtender
                    ID="MaskedEditExtender3"
                    runat="server"
                    TargetControlID="txtND_Ngaysinh"
                    Mask="99/99/9999"
                    MaskType="Date"
                    CultureName="vi-VN"
                    ErrorTooltipEnabled="true"
                  />
                  Năm sinh<span class="batbuoc">(*)</span>
                  <asp:TextBox
                    ID="txtND_Namsinh"
                    CssClass="user"
                    onkeypress="return isNumber(event)"
                    runat="server"
                    Width="35px"
                    MaxLength="4"
                  ></asp:TextBox>
                   
                    <asp:Button ID="cmdGet037" runat="server" Text="Kiểm tra" OnClick="btnGet037_Click" CssClass="buttoninput" Height="25px" />
                    <asp:CheckBox ID="chkKhongLamSach" AutoPostBack="true" runat="server" Text="Không thể làm sạch được" OnCheckedChanged="chkKhongLamSach_CheckedChanged" />
                 </td>

            </tr>
            <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
              <tr>
                <td>Địa chỉ</td>
                <td>
                  <asp:DropDownList
                    ID="ddl_NDD_Tinh"
                    CssClass="chosen-select"
                    runat="server"
                    Width="123px"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddl_NDD_Tinh_SelectedIndexChanged"
                  ></asp:DropDownList>
                  <asp:DropDownList
                    ID="ddl_NDD_Huyen"
                    CssClass="chosen-select"
                    runat="server"
                    Width="123px" ClientIDMode="Static"
                  ></asp:DropDownList>
                </td>
                <td>Chi tiết</td>
                <td>
                  <asp:TextBox
                    ID="txtND_NDD_Diachichitiet"
                    CssClass="user"
                    runat="server"
                    Width="242px"
                    MaxLength="250"
                  ></asp:TextBox>
                </td>
              </tr>
              <tr>
                <td>Người đại diện</td>
                <td>
                  <asp:TextBox
                    ID="txtND_NDD_Ten"
                    CssClass="user"
                    runat="server"
                    Width="242px"
                    MaxLength="250"
                  ></asp:TextBox>
                </td>
                <td>Chức vụ</td>
                <td>
                  <asp:TextBox
                    ID="txtND_NDD_Chucvu"
                    CssClass="user"
                    runat="server"
                    Width="242px"
                    MaxLength="250"
                  ></asp:TextBox>
                </td>
              </tr>
            </asp:Panel>
           
            <tr>
              <td>
                Thẻ căn cước
                <asp:Literal ID="ltCCCDND" runat="server"></asp:Literal>
              </td>
              <td>
                <asp:TextBox
                  ID="txtND_CCCD"
                  CssClass="user"
                  runat="server"
                  Width="242px"
                  MaxLength="250"
                ></asp:TextBox>
              </td>
              <td>Quốc tịch<span class="batbuoc">(*)</span></td>
              <td>
                <asp:DropDownList
                  ID="ddlND_Quoctich"
                  CssClass="chosen-select"
                  runat="server"
                  Width="250px"
                  AutoPostBack="True"
                  OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged"
                ></asp:DropDownList>
              </td>
            </tr>
            <tr>
              <td>
                Số CMND <asp:Literal ID="ltCMNDND" runat="server"></asp:Literal>
              </td>
              <td>
                <asp:TextBox
                  ID="txtND_CMND"
                  CssClass="user"
                  runat="server"
                  Width="242px"
                  MaxLength="250"  ClientIDMode="Static"
                ></asp:TextBox>
              </td>
              <td>
                Hộ chiếu <asp:Literal ID="ltHCND" runat="server"></asp:Literal>
              </td>
              <td>
                <asp:TextBox
                  ID="txtND_HoChieu"
                  CssClass="user"
                  runat="server"
                  Width="242px"
                  MaxLength="250"
                ></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td></td>
              <td colspan="3">
                <asp:CheckBox
                  ID="chkBoxCMNDND"
                  AutoPostBack="true"
                  runat="server"
                  Text="Không có"
                  OnCheckedChanged="chkBoxCMNDND_CheckedChanged"
                />
              </td>
            </tr>
            <asp:Panel ID="pnNDCanhan" runat="server">
              <tr>
                <td>Giới tính</td>
                <td colspan ="3">
                  <asp:DropDownList
                    ID="ddlND_Gioitinh"
                    CssClass="chosen-select"
                    runat="server"
                    Width="250px"  ClientIDMode="Static">
                    <asp:ListItem Value="0" Text="Chọn" Selected ="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                  </asp:DropDownList>
                </td>
                
              </tr>
              <tr>
                <td></td>
                <td colspan="3">
                  <asp:CheckBox
                    ID="chkONuocNgoai"
                    AutoPostBack="true"
                    runat="server"
                    Text="Có yếu tố nước ngoài"
                    OnCheckedChanged="chkONuocNgoai_CheckedChanged"
                  />
                </td>
              </tr>
              <%--
              <tr>
                <td>
                  Thường trú<asp:Label
                    ID="lblBatbuoc1"
                    runat="server"
                    ForeColor="Red"
                    Text="(*)"
                  ></asp:Label>
                </td>
                <td>
                  <asp:DropDownList
                    ID="ddlThuongTruTinh"
                    CssClass="chosen-select"
                    runat="server"
                    Width="49%"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlThuongTruTinh_SelectedIndexChanged"
                  ></asp:DropDownList>
                  <asp:DropDownList
                    ID="ddlThuongTruHuyen"
                    CssClass="chosen-select"
                    runat="server"
                    Width="49%"
                  ></asp:DropDownList>
                </td>

                <td>Chi tiết</td>

                <td>
                  <asp:TextBox
                    ID="txtND_HKTT_Chitiet"
                    CssClass="user"
                    runat="server"
                    Width="242px"
                    MaxLength="250"
                  ></asp:TextBox>
                </td>
              </tr>
              --%>

              <tr>
                <td>
                  Nơi cư trú<asp:Label
                    ID="lblBatbuoc2"
                    runat="server"
                    ForeColor="Red"
                    Text="(*)"
                  ></asp:Label>
                </td>

                <td>
                  <asp:DropDownList
                    ID="ddlNoiSongTinh"
                    CssClass="chosen-select"
                    runat="server"
                    Width="123px"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlNoiSongTinh_SelectedIndexChanged"  ClientIDMode="Static"></asp:DropDownList>
                  <asp:DropDownList
                    ID="ddlNoiSongHuyen"
                    CssClass="chosen-select"
                    runat="server"
                    Width="123px"  ClientIDMode="Static"></asp:DropDownList>
                </td>
                <td>Chi tiết</td>
                <td>
                  <asp:TextBox
                    ID="txtND_TTChitiet"
                    CssClass="user"
                    runat="server"
                    Width="242px"
                    MaxLength="250"  ClientIDMode="Static"
                  ></asp:TextBox>
                </td>
              </tr>

              <tr>
                <td>Nơi làm việc</td>
                <td colspan="3">
                  <asp:TextBox
                    ID="txt_NoiLamViec"
                    CssClass="user"
                    runat="server"
                    Width="590px"
                    MaxLength="500"
                  ></asp:TextBox>
                </td>
              </tr>
            </asp:Panel>
            <tr>
              <td>Email</td>
              <td>
                <asp:TextBox
                  ID="txtEmail"
                  CssClass="user"
                  runat="server"
                  Width="242px"
                  MaxLength="250"
                ></asp:TextBox>
              </td>
              <td>Điện thoại</td>
              <td>
                <asp:TextBox
                  ID="txtDienthoai"
                  runat="server"
                  CssClass="user"
                  Width="103px"
                ></asp:TextBox>
                Fax
                <asp:TextBox
                  ID="txtFax"
                  runat="server"
                  CssClass="user"
                  Width="103px"
                ></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td colspan="4" align="center">
                <div>
                  <asp:HiddenField ID="hddid" runat="server" Value="0" />
                  <asp:Label
                    runat="server"
                    ID="lbthongbao"
                    ForeColor="Red"
                  ></asp:Label>
                </div>
              </td>
            </tr>
            <tr>
              <td colspan="4" align="center">
                <asp:Button
                  ID="cmdUpdate"
                  runat="server"
                  CssClass="buttoninput"
                  Text="Lưu"
                  OnClick="btnUpdate_Click" OnClientClick="this.disabled=true; this.value='Đang lưu...';__doPostBack(this.name,'');"
                />
                <asp:Button
                  ID="cmdLammoi"
                  runat="server"
                  CssClass="buttoninput"
                  Text="Làm mới"
                  OnClick="btnLammoi_Click"
                />
              </td>
            </tr>
          </table>
        </div>
      </div>
      <div class="truong">
        <table class="table1">
          <tr>
            <td colspan="2">
              <asp:Panel runat="server" ID="pndata" Visible="false">
                <div class="phantrang">
                  <div class="sobanghi">
                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                  </div>
                  <div class="sotrang">
                    <asp:LinkButton
                      ID="lbTBack"
                      runat="server"
                      CausesValidation="false"
                      CssClass="back"
                      OnClick="lbTBack_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbTFirst"
                      runat="server"
                      CausesValidation="false"
                      CssClass="active"
                      Text="1"
                      OnClick="lbTFirst_Click"
                    ></asp:LinkButton>
                    <asp:Label
                      ID="lbTStep1"
                      runat="server"
                      Text="..."
                    ></asp:Label>
                    <asp:LinkButton
                      ID="lbTStep2"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="2"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbTStep3"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="3"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbTStep4"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="4"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbTStep5"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="5"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:Label
                      ID="lbTStep6"
                      runat="server"
                      Text="..."
                    ></asp:Label>
                    <asp:LinkButton
                      ID="lbTLast"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="100"
                      OnClick="lbTLast_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbTNext"
                      runat="server"
                      CausesValidation="false"
                      CssClass="next"
                      OnClick="lbTNext_Click"
                    ></asp:LinkButton>
                  </div>
                </div>
                <asp:DataGrid
                  ID="dgList"
                  runat="server"
                  AutoGenerateColumns="False"
                  CellPadding="4"
                  PageSize="20"
                  AllowPaging="True"
                  GridLines="None"
                  PagerStyle-Mode="NumericPages"
                  CssClass="table2"
                  HeaderStyle-CssClass="header"
                  AlternatingItemStyle-CssClass="le"
                  ItemStyle-CssClass="chan"
                  Width="100%"
                  OnItemCommand="dgList_ItemCommand"
                  OnItemDataBound="dgList_ItemDataBound"
                >
                  <Columns>
                    <asp:TemplateColumn
                      HeaderStyle-Width="20px"
                      ItemStyle-Width="20px"
                      HeaderStyle-HorizontalAlign="Center"
                      ItemStyle-HorizontalAlign="Center"
                    >
                      <HeaderTemplate> TT </HeaderTemplate>
                      <ItemTemplate>
                        <%# Container.DataSetIndex + 1 %>
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                      <HeaderTemplate> Tên đương sự </HeaderTemplate>
                      <ItemTemplate> <%#Eval("TENDUONGSU") %> </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                      <HeaderTemplate> Địa chỉ </HeaderTemplate>
                      <ItemTemplate> <%#Eval("DIACHIDS") %> </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                      HeaderStyle-Width="50px"
                      HeaderStyle-HorizontalAlign="Center"
                      ItemStyle-HorizontalAlign="Center"
                    >
                      <HeaderTemplate> Đương sự là </HeaderTemplate>
                      <ItemTemplate> <%#Eval("TENLOAIDS") %> </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                      HeaderStyle-Width="80px"
                      HeaderStyle-HorizontalAlign="Center"
                      ItemStyle-HorizontalAlign="Center"
                    >
                      <HeaderTemplate> Tư cách tố tụng </HeaderTemplate>
                      <ItemTemplate> <%#Eval("TENTCTT") %> </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                      HeaderStyle-Width="50px"
                      HeaderStyle-HorizontalAlign="Center"
                      ItemStyle-HorizontalAlign="Center"
                    >
                      <HeaderTemplate> Đại diện </HeaderTemplate>
                      <ItemTemplate> <%#Eval("DAIDIEN") %> </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                      HeaderStyle-Width="80px"
                      HeaderStyle-HorizontalAlign="Center"
                      ItemStyle-HorizontalAlign="Center">
                      <HeaderTemplate> Trạng thái xác thực </HeaderTemplate>
                      <ItemTemplate> <%#Eval("TANGTHAIXACTHUC") %> </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn
                      DataField="NGUOITAO"
                      HeaderText="Người tạo"
                      HeaderStyle-Width="65px"
                      HeaderStyle-HorizontalAlign="Center"
                    ></asp:BoundColumn>
                    <asp:BoundColumn
                      DataField="NGAYTAO"
                      HeaderText="Ngày tạo"
                      HeaderStyle-Width="65px"
                      HeaderStyle-HorizontalAlign="Center"
                      DataFormatString="{0:dd/MM/yyyy HH:mm}"
                    ></asp:BoundColumn>
                    <asp:TemplateColumn
                      HeaderStyle-Width="80px"
                      ItemStyle-Width="80px"
                      HeaderStyle-HorizontalAlign="Center"
                      ItemStyle-HorizontalAlign="Center"
                    >
                      <HeaderTemplate> Thao tác </HeaderTemplate>
                      <ItemTemplate>
                        <asp:LinkButton
                          ID="lblXem"
                          runat="server"
                          Text="Sửa"
                          CausesValidation="false"
                          CommandName="Xem"
                          ForeColor="#0e7eee"
                          
                         CommandArgument='<%#Eval("ID") %>' Visible='<%# IsShowDetail(Eval("TOA_GIAIQUYET_ID")) %>'></asp:LinkButton>
                        &nbsp;&nbsp;<asp:LinkButton
                          ID="lblSua"
                          runat="server"
                          Text="Sửa"
                          CausesValidation="false"
                          CommandName="Sua"
                          ForeColor="#0e7eee"
                          CommandArgument='<%#Eval("ID") %>'
                        ></asp:LinkButton>
                        &nbsp;&nbsp;<asp:LinkButton
                          ID="lbtXoa"
                          runat="server"
                          CausesValidation="false"
                          Text="Xóa"
                          ForeColor="#0e7eee"
                          CommandName="Xoa"
                          CommandArgument='<%#Eval("ID") %>'
                          ToolTip="Xóa"
                          OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"
                        ></asp:LinkButton>
                         <br /><asp:LinkButton
                          ID="lblHis"
                          runat="server"
                          Text="Xem lịch sử"
                          CausesValidation="false"
                          CommandName="his"
                          ForeColor="#0e7eee"
                          CommandArgument='<%#Eval("ID") %>'
                        ></asp:LinkButton>
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn
                      DataField="TOA_GIAIQUYET_ID"
                      Visible="false"
                    ></asp:BoundColumn>
                  </Columns>
                  <HeaderStyle CssClass="header"></HeaderStyle>
                  <ItemStyle CssClass="chan"></ItemStyle>
                  <PagerStyle Visible="false"></PagerStyle>
                </asp:DataGrid>
                <div class="phantrang">
                  <div class="sobanghi">
                    <asp:HiddenField ID="hdicha" runat="server" />
                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                  </div>
                  <div class="sotrang">
                    <asp:LinkButton
                      ID="lbBBack"
                      runat="server"
                      CausesValidation="false"
                      CssClass="back"
                      OnClick="lbTBack_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbBFirst"
                      runat="server"
                      CausesValidation="false"
                      CssClass="active"
                      Text="1"
                      OnClick="lbTFirst_Click"
                    ></asp:LinkButton>
                    <asp:Label
                      ID="lbBStep1"
                      runat="server"
                      Text="..."
                    ></asp:Label>
                    <asp:LinkButton
                      ID="lbBStep2"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="2"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbBStep3"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="3"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbBStep4"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="4"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbBStep5"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="5"
                      OnClick="lbTStep_Click"
                    ></asp:LinkButton>
                    <asp:Label
                      ID="lbBStep6"
                      runat="server"
                      Text="..."
                    ></asp:Label>
                    <asp:LinkButton
                      ID="lbBLast"
                      runat="server"
                      CausesValidation="false"
                      CssClass="so"
                      Text="100"
                      OnClick="lbTLast_Click"
                    ></asp:LinkButton>
                    <asp:LinkButton
                      ID="lbBNext"
                      runat="server"
                      CausesValidation="false"
                      CssClass="next"
                      OnClick="lbTNext_Click"
                    ></asp:LinkButton>
                  </div>
                </div>
              </asp:Panel>
            </td>
          </tr>
        </table>
      </div>
    </div>
  </div>
  
    <script type="text/javascript">
        function PopupCenter(url, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var newWindow = window.open(url, title,
                'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width='
                + w + ', height=' + h + ', top=' + top + ', left=' + left);

            if (window.focus) {
                newWindow.focus();
            }
        }
    </script>
      <script type="text/javascript">
          function pageLoad(sender, args) {
              var config = {
                  ".chosen-select": {},
                  ".chosen-select-deselect": { allow_single_deselect: true },
                  ".chosen-select-no-single": { disable_search_threshold: 10 },
                  ".chosen-select-no-results": {
                      no_results_text: "Oops, nothing found!",
                  },
                  ".chosen-select-rtl": { rtl: true },
                  ".chosen-select-width": { width: "95%" },
              };
              for (var selector in config) {
                  $(selector).chosen(config[selector]);
              }
              // cập nhật lại UI của Chosen
              $(".chosen-select").trigger("chosen:updated");
              var hidHuyen = document.getElementById('hidNoiSongHuyen');
              var ddlHuyen = document.getElementById('ddlNoiSongHuyen');
              if (hidHuyen && ddlHuyen && hidHuyen.value) {
                  ddlHuyen.value = hidHuyen.value;
                  $(".chosen-select").trigger("chosen:updated");
              }
          }
      </script>
</asp:Content>

