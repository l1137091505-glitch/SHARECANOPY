# SHARECANOPY 部署说明

## 1. 上传 GitHub

1. 在 GitHub 新建公开仓库，建议名称 `sharecanopy`。
2. 不要额外创建 README、License 或 `.gitignore`。
3. 解压 `SHARECANOPY-GITHUB-UPLOAD.zip`，将里面全部内容上传到仓库根目录并提交。

## 2. 在 Remix 新建合约

在 Remix 的 `contracts` 文件夹中新建：

`ShareCanopy.sol`

复制独立 `ShareCanopy.sol` 文件的全部代码，粘贴后按 `Ctrl+S` 保存。

## 3. 编译合约

1. 打开 **Solidity Compiler**。
2. 编译器选择 `0.8.24`。
3. 点击 **Compile ShareCanopy.sol**。
4. 出现绿色 `Compiled` 即可。

## 4. 部署到 BOT Chain

钱包网络参数：

- Network Name：`BOT Chain Mainnet`
- RPC URL：`https://rpc.botchain.ai`
- Chain ID：`677`
- Currency Symbol：`BOT`
- Block Explorer：`https://scan.botchain.ai`

在 Remix 打开 **Deploy & Run Transactions**：

1. Environment 选择 `Browser Extension`。
2. 确认钱包处于 BOT Chain Mainnet。
3. Contract 选择 `ShareCanopy - ShareCanopy.sol`。
4. 构造函数没有参数，直接点击 **Deploy**。
5. 在钱包确认交易。
6. 部署完成后复制完整合约地址。

## 5. 在 Vercel 部署

1. 在 Vercel 点击 **Add New → Project**，导入 GitHub 仓库。
2. Root Directory 选择 `frontend`。
3. Framework Preset 选择 `Vite`。
4. 添加环境变量：

```text
Key: VITE_SHARECANOPY_ADDRESS
Value: 0x你的完整合约地址
Type: Config
Environment: Production
```

合约地址是公开信息，不需要选择 Secret。不要填写钱包私钥或助记词。

5. 点击 **Deploy**。
6. 如果在首次部署后才添加环境变量，必须进入 **Deployments → Redeploy**，且不要使用旧 Build Cache。

## 6. 创建分配轮次

1. 在 `Round name` 填写分配名称。
2. 在 `Total funding` 填写本次总 BOT 金额。
3. 在 `Claim window` 填写领取期限天数，范围 1–365。
4. 在地址清单中每行填写：

```text
0x钱包地址, 权重
```

例如：

```text
0x1111111111111111111111111111111111111111, 50
0x2222222222222222222222222222222222222222, 30
0x3333333333333333333333333333333333333333, 20
```

权重可以是任意正数；上面分别获得总金额的 50%、30%、20%。最多填写 100 个不重复地址。

5. 点击 `Open distribution on BOT Chain`。
6. 选择钱包并确认交易。交易的 Value 就是填写的总 BOT 金额。

## 7. 领取 BOT

1. 使用清单中的钱包连接网页。
2. 在 Claim 区域填写 Round ID。
3. 点击 `Check allocation` 查看额度。
4. 点击 `Claim BOT share` 并确认交易。

领取期限结束后，创建者可以通过合约的 `reclaim(roundId)` 取回没有领取的剩余 BOT。目前网页没有提供 reclaim 按钮，可在 Remix 的 Deployed Contracts 中操作。

## 8. 安全说明

- 本项目只支持原生 BOT，不支持 ERC-20。
- 地址和权重会公开上链。
- 不要把交易所充值地址当作接收地址。
- 合约未经专业审计，先用少量 BOT 测试。
- 绝对不要上传私钥或助记词。
