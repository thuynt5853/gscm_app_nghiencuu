<%@ Page Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhmucngaynghi.aspx.cs" Inherits="WEB.GSTP.Danhmuc.Danhmucngaynghi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<div class="box">
    <div class="box_nd">
        <div class="truong">
          <table class="table1">
                <tr>
                    <td style="width: 120px;">
                        <b>Ngày nghỉ lễ </b>
                        <asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtNgayNghi" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNghi" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 120px;">
                        <b>Mô tả</b> 
                    </td>
                    <td>
                        <asp:TextBox ID="txtMoTa" CssClass="user" runat="server" Width="150px" MaxLength="50"></asp:TextBox>
                    </td>
                </tr>
                 <tr>
                    <td style="width: 120px;">
                        <b>Năm</b> <asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox Enabled="false" ID="txtNam" CssClass="user" runat="server" Width="150px" MaxLength="50"></asp:TextBox>
                    </td>
                </tr>
              <tr>
                  <td colspan="2"></td>
              </tr>
                <tr>
                    <td></td>
                    <td>
                          <asp:button id="cmdUpdate" runat="server" cssclass="buttoninput" text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return KtratenDV()" />

                          <asp:button id="cmdLammoi" runat="server" cssclass="buttoninput" text="Làm mới" onclick="btnLammoi_Click" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div>
                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </div>
                        <asp:Panel runat="server" ID="pndata" Visible="false">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="40px" ItemStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thứ tự
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                           <%# Container.DataSetIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="NGAYNGHI" HeaderText="Ngày nghỉ lễ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Mô tả
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("MOTA") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Năm
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NAM") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua"   ForeColor="#0e7eee"
                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"   ForeColor="#0e7eee"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
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
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                            
                        </asp:Panel>
                    </td>
                </tr>
            </table>

        </div>
    </div>
</div>
<asp:HiddenField ID="hddGUID" runat="server" Value="0" />
<script language="javascript" type="text/javascript">
   
    function KtratenDV() {
        //if ((txtMa.value.trim() == null || txtMa.value.trim() == "") && txtID.value !="0") {
        //    alert('Bạn hãy nhập mã danh mục !');
        //    txtMa.focus();
        //    return false;
        //}
        //if (txtTen.value.trim() == null || txtTen.value.trim() == "") {
        //    alert('Bạn hãy nhập tên danh mục !');
        //    txtTen.focus();
        //    return false;
        //}
        return true;
    }
</script>


</asp:Content>
